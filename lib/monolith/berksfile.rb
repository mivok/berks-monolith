require 'berkshelf'

module Monolith
  class Berksfile
    attr_reader :berksfile

    def initialize(options)
      begin
        @berksfile = Berkshelf::Berksfile.from_options(options)
      rescue Berkshelf::BerksfileNotFound => e
        Monolith.formatter.error(e)
        exit(e.status_code)
      end
    end

    # Retrieve all cookbooks listed in the berksfile, ensuring they're
    # installed first.
    #
    # Can take a block to do something with each cookbook.
    def cookbooks(path)
      Berkshelf.ui.mute! if Monolith.formatter.quiet
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

    def monolith_action(action, cookbook, dep, destination)
      obj = monolith_obj(dep)
      if obj.nil?
        Monolith.formatter.unsupported_location(cookbook, dep)
      else
        Monolith.formatter.send(action, cookbook, destination)
        obj.send(action, destination)
      end
    end

    # Feteches the appropriate monolith location object for a given cookbook
    # dependency. I.e. Monolith::FooLocation.
    def monolith_obj(dep)
      klass = dep.location.class.name.split('::')[-1]
      if Monolith.const_defined?(klass)
        Monolith.const_get(klass).new(dep.location)
      end
    end
  end
end
