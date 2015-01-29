# If a Berksfile mentions a cookbook with a path location, then we can
# assume it's already available locally in a form suitable for
# development. An example of this is if you have a (mostly) monolithic
# chef repository and want to refer to cookbooks in this repository in
# your Berksfile.
module Monolith
  class PathLocation < BaseLocation
    def install
      Monolith.formatter.debug("Skipping cookbook #{@cookbook.cookbook_name}" \
                               "with path location")
      nil
    end

    def update
      Monolith.formatter.debug("Skipping cookbook #{@cookbook.cookbook_name}" \
                               "with path location")
      nil
    end

    def clean
      Monolith.formatter.debug("Skipping cookbook #{@cookbook.cookbook_name}" \
                               "with path location")
      nil
    end
  end
end
