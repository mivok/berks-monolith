module Berkshelf
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
    end
  end
end
