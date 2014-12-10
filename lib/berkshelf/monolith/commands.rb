module Berkshelf
  module Monolith
    class Command < Thor
      desc 'install [PATH]', 'Clone all cookbooks into the cookbooks directory'
      def install(path = File.join(Dir.pwd, "cookbooks"))
        berksfile = Berkshelf::Berksfile.from_options(options)
        cached_cookbooks = berksfile.install
        #require 'pry'; binding.pry
        return nil if cached_cookbooks.empty?
        cached_cookbooks.each do |cookbook|
          # TODO - make a monolith formatter
          Berkshelf.formatter.vendor(cookbook, path)
          destination = File.join(path, cookbook.cookbook_name)
          dep = berksfile.get_dependency(cookbook.cookbook_name)
          if dep and dep.location
            # Look for Berkshelf::Monolith::FooLocation for the location
            # object and use it for installation if needed.
            klass = dep.location.class.name.split('::')[-1]
            Berkshelf.log.debug("Location class name: #{klass}")
            if Berkshelf::Monolith.const_defined?(klass)
              Berkshelf.log.debug("Found monolith class for #{klass}")
              obj = Berkshelf::Monolith.const_get(klass).new(dep.location)
              obj.install(destination)
            end
            next
          end
          # We don't have a custom method for installing this type of
          # cookbook, so fall back to copying it from the cached location.
          Berkshelf.log.debug(
            "No monolith class for #{klass}, falling back to FileSyncer")
          FileSyncer.sync(cookbook.path, destination)
        end
      end
    end
  end

  class Cli < Thor
    desc 'monolith SUBCOMMAND', 'Help berkshelf run as a monolithic repository'
    subcommand 'monolith', Berkshelf::Monolith::Command
  end
end
