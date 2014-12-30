# If a Berksfile mentions a cookbook with a path location, then we can
# assume it's already available locally in a form suitable for
# development. An example of this is if you have a (mostly) monolithic
# chef repository and want to refer to cookbooks in this repository in
# your Berksfile.
module Berkshelf
  module Monolith
    class PathLocation < BaseLocation
      def install(destination)
        # Don't actually do anything
      end

      def update(destination)
        # Don't actually do anything
      end

      def clean(destination)
        # Don't actually do anything
      end
    end
  end
end
