module Monolith
  class BaseLocation
    attr_reader :location # The Berkshelf::FooLocation object
    def initialize(location)
      @location = location
    end

    # Install the cookbook in the development environment. If possible, the
    # installed cookbook should look exactly as it would when used for
    # development (e.g. a git checkout with all git metadata, no compiled
    # artefacts).
    def install(destination)
      nil
    end

    # Update the cookbook in the development environment to the latest
    # version. E.g. if git is used, run git pull.
    def update(destination)
      nil
    end

    # Remove a previously installed cookbook. If a cookbook was never
    # installed in the first place (either because install wasn't run, or
    # because of the location type), then this should do nothing.
    def clean(destination)
      if File.exist?(destination)
        Monolith.formatter.msg("Deleting #{destination}")
        FileUtils.rm_rf(destination)
      else
        Monolith.formatter.msg("#{destination} doesn't exist. Skipping.")
      end
    end
  end
end
