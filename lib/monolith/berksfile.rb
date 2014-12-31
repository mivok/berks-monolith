require 'berkshelf'

module Monolith
  class Berksfile
    attr_reader :berksfile

    def initialize(options)
      Berkshelf.ui.mute! if Monolith.formatter.quiet
      begin
        @berksfile = Berkshelf::Berksfile.from_options(options)
      rescue Berkshelf::BerksfileNotFound => e
        Monolith.formatter.error(e)
        exit(e.status_code)
      end
    end

    # Runs berks install. This is needed before we install cookbooks ourselves
    # to make sure berkshelf has a local copy of them for us to clone from or
    # copy. However, it's not needed for other commands, so it separated out
    # here.
    def install
      @berksfile.install
    end

    # Retrieve all cookbooks listed in the berksfile.
    #
    # Can take a block to do something with each cookbook.
    def cookbooks(path)
      cached_cookbooks = @berksfile.cookbooks
      if block_given?
        cached_cookbooks.each do |cookbook|
          destination = File.join(File.expand_path(path),
                                  cookbook.cookbook_name)
          dep = berksfile.get_dependency(cookbook.cookbook_name)
          if dep
            yield cookbook, dep, destination
          end
        end
      end
      cached_cookbooks
    end

    def monolith_action(action, cookbook, dep, destination)
      obj = monolith_obj(cookbook, dep, destination)
      if obj.nil?
        Monolith.formatter.unsupported_location(cookbook, dep)
      else
        obj.send(action)
      end
    end

    # Feteches the appropriate monolith location object for a given cookbook
    # dependency. I.e. Monolith::FooLocation.
    def monolith_obj(cookbook, dep, destination)
      if dep.location.nil?
        Monolith::DefaultLocation.new(cookbook, dep, destination)
      else
        klass = dep.location.class.name.split('::')[-1]
        Monolith.formatter.debug("Location class for " \
                                 "#{cookbook.cookbook_name} is #{klass}")
        if Monolith.const_defined?(klass)
          Monolith.const_get(klass).new(cookbook, dep, destination)
        end
      end
    end
  end
end
