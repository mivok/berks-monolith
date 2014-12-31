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
  end

  def test_update_command
    make_berksfile([:git]) do
      # We need to install it first
      Monolith::Command.start(['install', '-q'])
      make_change_git('test_git')
      # Verify the 'before' state
      refute File.exist?("cookbooks/test_git/test.txt")
      # Perform the update
      Monolith::Command.start(['update', '-q'])
      assert File.exist?("cookbooks/test_git")
      assert File.exist?("cookbooks/test_git/.git")
      assert File.exist?("cookbooks/test_git/test.txt")
    end
  end
end
