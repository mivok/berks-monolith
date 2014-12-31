require 'berkshelf/mixin/git'
require_relative 'base'

module Monolith
  class GitLocation < BaseLocation
    include Berkshelf::Mixin::Git

    def install
      unless File.directory?(@destination)
        Monolith.formatter.install(@cookbook, @destination)
        # Clone from the cache. We've already done an install by this point, so
        # berkshelf already made sure the cache exists and is up to date.
        git %|clone "#{cache_path}" "#{@destination}"|

        # Make sure the origin is correct and doesn't point to the cached
        # version.
        cached_origin_url = origin_url(cache_path)
        set_origin_url(@destination, cached_origin_url)

        # Not sure if I want to do this - should probably be an option
        #git %|reset --hard #{@revision}|
      else
        rel_dest = Monolith.formatter.rel_dir(@destination)
        Monolith.formatter.skip(@cookbook, "#{rel_dest} already exists")
      end
    end

    def update
      if File.directory?(@destination)
        Monolith.formatter.update(@cookbook, @destination)
        Dir.chdir(@destination) do
          git %|pull|
        end
      else
        rel_dest = Monolith.formatter.rel_dir(@destination)
        Monolith.formatter.skip(@cookbook, "#{rel_dest} doesn't exist")
      end
    end

    private

    # Taken from Berkshelf::GitLocation
    def cache_path
      Pathname.new(Berkshelf.berkshelf_path)
        .join('.cache', 'git', Digest::SHA1.hexdigest(@location.uri))
    end

    def origin_url(repo_dir)
      Dir.chdir(repo_dir) do
        git %|config --local --get remote.origin.url|
      end
    end

    def set_origin_url(repo_dir, url)
      Dir.chdir(repo_dir) do
        git %|remote set-url origin "#{url}"|
      end
    end
  end
end
