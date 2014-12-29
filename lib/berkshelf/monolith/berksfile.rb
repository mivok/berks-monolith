require 'berkshelf'

module Berkshelf
  module Monolith
    class Berksfile
      attr_reader :berksfile

      def initialize(options)
        @berksfile = Berkshelf::Berksfile.from_options(options)
      end

      # Retrieve all cookbooks listed in the berksfile, ensuring they're
      # installed first.
      #
      # Can take a block to do something with each cookbook.
      def cookbooks(path)
        cached_cookbooks = @berksfile.install
        if block_given?
          cached_cookbooks.each do |cookbook|
            destination = File.join(path, cookbook.cookbook_name)
            dep = berksfile.get_dependency(cookbook.cookbook_name)
            if dep and dep.location
              yield cookbook, dep, destination
            end
          end
        end
        cached_cookbooks
      end

      # Feteches the appropriate monolith location object for a given cookbook
      # dependency. I.e. Berkshelf::Monolith::FooLocation.
      def monolith_obj(dep)
        klass = dep.location.class.name.split('::')[-1]
        Berkshelf.log.debug("Location class name: #{klass}")
        if Berkshelf::Monolith.const_defined?(klass)
          Berkshelf.log.debug("Found monolith class for #{klass}")
          Berkshelf::Monolith.const_get(klass).new(dep.location)
        else
          Berkshelf.log.debug("No monolith class found for #{klass}")
          nil
        end
      end
    end
  end
end
