require 'minitest/autorun'
require_relative 'helpers'

# Fix 'Celluloid::Error Thread pool is not running' error.
# See https://github.com/celluloid/celluloid/pull/162
require 'celluloid/test'
Celluloid.init

require 'monolith'

class TestCommandInstall < MiniTest::Test
  include Monolith::TestHelpers

  def setup
    clean_tmp_path
    setup_tmp_git_repo
  end

  def test_install_command
    efile = ".git/info/exclude"
    make_berksfile([:git, :path]) do
      Monolith::Command.start(['install', '-q'])
      assert File.exist?(efile)
      assert File.read(efile).include?("cookbooks/test_git")
      assert File.exist?("cookbooks/test_path")
      refute File.read(efile).include?("cookbooks/test_path")
    end
  end
end
