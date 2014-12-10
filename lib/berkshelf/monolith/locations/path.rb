module Berkshelf
  module Monolith
    class PathLocation < BaseLocation
      def install(destination)
        cb = @location.dependency.name
        Berkshelf.log.debug("Not installing cookbok #{cb} with a path location")
      end
    end
  end
end
