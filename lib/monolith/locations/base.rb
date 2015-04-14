module Monolith
  class BaseLocation
    def initialize(cookbook, dep, destination)
      @dep = dep
      @location = dep.location unless dep.nil?
      @cookbook = cookbook
      @destination = destination
    end

    # Install the cookbook in the development environment. If possible, the
    # installed cookbook should look exactly as it would when used for
    # development (e.g. a git checkout with all git metadata, no compiled
    # artefacts).
    def install
      nil
    end

    # Update the cookbook in the development environment to the latest
    # version. E.g. if git is used, run git pull.
    def update
      nil
    end

    # Remove a previously installed cookbook. If a cookbook was never
    # installed in the first place (either because install wasn't run, or
    # because of the location type), then this should do nothing.
    def clean
      if File.exist?(@destination)
        Monolith.formatter.clean(@cookbook, @destination)
        FileUtils.rm_rf(@destination)
        true
      else
        rel_dest = Monolith.formatter.rel_dir(@destination)
        Monolith.formatter.skip(@cookbook, "#{rel_dest} doesn't exist")
        nil
      end
    end
  end
end
