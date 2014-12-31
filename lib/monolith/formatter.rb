module Monolith
  class Formatter
    attr_accessor :quiet
    attr_accessor :debug

    def initialize
      @quiet = false
      @debug = false
      @base_path = Pathname.new(Dir.pwd)
    end

    def install(cookbook, destination)
      msg "Installing #{cookbook.cookbook_name} to #{rel_dir(destination)}"
    end

    def update(cookbook, destination)
      msg "Updating #{cookbook.cookbook_name} at #{rel_dir(destination)}"
    end

    def clean(cookbook, destination)
      msg "Removing #{cookbook.cookbook_name} from #{rel_dir(destination)}"
    end

    def skip(cookbook, reason)
      msg "Skipping #{cookbook.cookbook_name} (#{reason})"
    end

    def unsupported_location(cookbook, dep)
      loctype = dep.location.class.name.split('::')[-1]
      msg "Unsupported location type #{loctype} for cookbook " \
        "#{cookbook.cookbook_name}. Skipping."
    end

    def debug(msg)
      puts "DEBUG: #{msg}" if @debug
    end

    def msg(msg)
      puts msg unless @quiet
    end

    def error(msg)
      STDERR.puts msg
    end

    def rel_dir(dir)
      return Pathname.new(dir).relative_path_from(@base_path)
    end
  end
end
