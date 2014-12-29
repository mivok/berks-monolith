require 'thor'
require 'berkshelf/monolith/berksfile'

module Berkshelf
  module Monolith
    class Command < Thor
      namespace ''

      desc 'install [PATH]', 'Clone all cookbooks into the cookbooks directory'
      def install(path = File.join(Dir.pwd, "cookbooks"))
        berksfile = Berkshelf::Monolith::Berksfile.new(options.dup)
        berksfile.cookbooks(path) do |cookbook, dep, destination|
          # TODO - make a monolith formatter
          Berkshelf.formatter.vendor(cookbook, path)
          obj = berksfile.monolith_obj(dep)
          if obj
            obj.install(destination)
          else
            # We don't have a custom method for installing this type of
            # cookbook, so fall back to copying it from the cached location.
            Berkshelf.log.debug('Falling back to FileSyncer')
            FileSyncer.sync(cookbook.path, destination)
          end
        end
      end

      desc 'update [PATH]', 'Update all cloned cookbooks'
      def update(path = File.join(Dir.pwd, "cookbooks"))
        berksfile = Berkshelf::Monolith::Berksfile.new(options.dup)
        berksfile.cookbooks(path) do |cookbook, dep, destination|
          obj = berksfile.monolith_obj(dep)
          if obj
            Berkshelf.formatter.msg("Updating #{cookbook}")
            obj.update(destination)
          else
            Berkshelf.log.debug("Skipping #{cookbook}")
          end
        end
      end
    end
  end
end
