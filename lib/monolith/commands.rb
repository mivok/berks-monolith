require 'thor'
require 'monolith/berksfile'
require 'monolith/formatter'
require 'monolith/gitexclude'
require 'monolith/version'

module Monolith
  class Command < Thor
    namespace ''

    class_option :quiet,
      :type => :boolean,
      :desc => "Don't print out any informational messages",
      :aliases => '-q',
      :default => false

    class_option :debug,
      :type => :boolean,
      :desc => 'Print additional debug messages',
      :aliases => '-d',
      :default => false

    class_option :berksfile,
      :desc => 'Location of the Berksfile to use',
      :aliases => '-b'

    class_option :git_exclude,
      :type => :boolean,
      :desc => 'Add installed cookbooks to git exclude file',
      :default => true

    def initialize(*args)
      super(*args)

      Monolith.formatter.quiet = @options[:quiet]
      Monolith.formatter.debug = @options[:debug]
    end

    desc 'install [PATH]', 'Clone all cookbooks into the cookbooks directory'
    def install(path = File.join(Dir.pwd, "cookbooks"))
      berksfile = Monolith::Berksfile.new(options.dup)
      berksfile.install # We need to run berks install first
      gitpath = File.expand_path('../.git', berksfile.berksfile.filepath)
      gitexclude = GitExclude.new(gitpath, options)
      berksfile.cookbooks(path) do |cookbook, dep, destination|
        changed = berksfile.monolith_action(:install, cookbook, dep, destination)

        gitexclude.add(destination) if changed
      end
      gitexclude.update
    end

    desc 'update [PATH]', 'Update all cloned cookbooks'
    def update(path = File.join(Dir.pwd, "cookbooks"))
      berksfile = Monolith::Berksfile.new(options.dup)
      berksfile.install # We need to run berks install first
      berksfile.cookbooks(path) do |cookbook, dep, destination|
        berksfile.monolith_action(:update, cookbook, dep, destination)
      end
    end

    desc 'clean [PATH]', 'Delete all cloned cookbooks'
    def clean(path = File.join(Dir.pwd, "cookbooks"))
      berksfile = Monolith::Berksfile.new(options.dup)
      # This is counter-intuitive given we're actually getting rid of the
      # cookbooks. This performs the dependency resolution needed to work out
      # what we need to remove.
      berksfile.install
      gitpath = File.expand_path('../.git', berksfile.berksfile.filepath)
      gitexclude = GitExclude.new(gitpath, options)
      berksfile.cookbooks(path) do |cookbook, dep, destination|
        changed = berksfile.monolith_action(:clean, cookbook, dep, destination)
        gitexclude.remove(destination) if changed
      end
      gitexclude.update
    end

    desc 'version', 'Print the version of berks-monlith'
    def version
      puts Monolith::VERSION
    end
  end
end
