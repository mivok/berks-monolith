module Monolith
  class Formatter
    attr_accessor :quiet

    def initialize(quiet = false)
      @quiet = quiet
    end

    def install(cookbook, destination)
      msg "Installing #{cookbook.cookbook_name} to #{destination}"
    end

    def update(cookbook, destination)
      msg "Updating #{cookbook.cookbook_name} at #{destination}"
    end

    def clean(cookbook, destination)
      msg "Removing #{cookbook.cookbook_name} from #{destination}"
    end

    def unsupported_location(cookbook, dep)
      loctype = dep.location.class.name.split('::')[-1]
      msg "Unsupported location type #{loctype} for cookbook " \
        "#{cookbook.cookbook_name}. Skipping."
    end

    def msg(msg)
      puts msg unless @quiet
    end
  end
end
