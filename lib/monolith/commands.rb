require 'thor'
require 'monolith/berksfile'
require 'monolith/formatter'

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

    def initialize(*args)
      super(*args)

      Monolith.formatter.quiet = @options[:quiet]
      Monolith.formatter.debug = @options[:debug]
    end

    desc 'install [PATH]', 'Clone all cookbooks into the cookbooks directory'
    def install(path = File.join(Dir.pwd, "cookbooks"))
      berksfile = Monolith::Berksfile.new(options.dup)
      berksfile.install # We need to run berks install first
      berksfile.cookbooks(path) do |cookbook, dep, destination|
        berksfile.monolith_action(:install, cookbook, dep, destination)
      end
    end

    desc 'update [PATH]', 'Update all cloned cookbooks'
    def update(path = File.join(Dir.pwd, "cookbooks"))
      berksfile = Monolith::Berksfile.new(options.dup)
      berksfile.cookbooks(path) do |cookbook, dep, destination|
        berksfile.monolith_action(:update, cookbook, dep, destination)
      end
    end

    desc 'clean [PATH]', 'Delete all cloned cookbooks'
    def clean(path = File.join(Dir.pwd, "cookbooks"))
      berksfile = Monolith::Berksfile.new(options.dup)
      berksfile.cookbooks(path) do |cookbook, dep, destination|
        berksfile.monolith_action(:clean, cookbook, dep, destination)
      end
    end
  end
end
