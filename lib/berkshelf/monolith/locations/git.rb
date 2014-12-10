require 'berkshelf/mixin/git'
require_relative 'base'

module Berkshelf
  module Monolith
    class GitLocation < BaseLocation
      include Mixin::Git

      def install(destination)
        # Clone from the cache. We've already done an install by this point, so
        # berkshelf already made sure the cache exists and is up to date.
        git %|clone "#{cache_path}" "#{destination}"|

        cached_origin_url = Dir.chdir(cache_path) do
          git %|config --local --get remote.origin.url|
        end

        Dir.chdir(destination) do
          # Make sure the origin is correct and doesn't point to the cached
          # version.
          git %|remote set-url origin "#{cached_origin_url}"|

          # Not sure if I want to do this - should probably be an option
          #git %|reset --hard #{@revision}|
        end
      end

      private

      # Taken from Berkshelf::GitLocation
      def cache_path
        Pathname.new(Berkshelf.berkshelf_path)
          .join('.cache', 'git', Digest::SHA1.hexdigest(location.uri))
      end
    end
  end
end
