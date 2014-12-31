# Default location aka community/supermarket cookbook
module Monolith
  class DefaultLocation < BaseLocation
    def install
      # For now we just copy any community cookbooks. It would be nice to be
      # able to grab them from the source URL, but that isn't readily
      # accessible, and then you have to guess how to check it out.
      if File.directory?(@destination)
        rel_dest = Monolith.formatter.rel_dir(@destination)
        Monolith.formatter.skip("#{rel_dest} already exists")
      else
        Monolith.formatter.install(@cookbook, @destination)
        FileUtils.cp_r(@cookbook.path, @destination)
      end
    end

    def update
      # There isn't anything to do for updating a community cookbook except
      # blowing it away and recreating it. For the moment I'm opting not to do
      # that (it may be able ot be an option later)
      Monolith.formatter.skip("Not updating community cookbook")
    end
  end
end
