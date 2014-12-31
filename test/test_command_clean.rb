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

  def test_clean_command
    make_berksfile([:git]) do
      # We need to install it first
      Monolith::Command.start(['install', '-q'])
      make_change_git('test_git')
      # Verify the 'before' state
      assert File.exist?("cookbooks/test_git")
      # Perform the clean
      Monolith::Command.start(['clean', '-q'])
      refute File.exist?("cookbooks/test_git")
    end
  end
end
