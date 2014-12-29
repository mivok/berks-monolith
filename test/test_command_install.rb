require 'minitest/autorun'
require_relative 'helpers'

# Fix 'Celluloid::Error Thread pool is not running' error.
# See https://github.com/celluloid/celluloid/pull/162
require 'celluloid/test'
Celluloid.init

require 'berkshelf/monolith'

class TestCommandInstall < MiniTest::Test
  include Monolith::TestHelpers

  def setup
    clean_tmp_path
  end

  def test_install_command
    make_berksfile([:git]) do
      Berkshelf.set_format('null') # Don't print output
      Berkshelf::Monolith::Command.start(['install'])
      assert File.exist?("cookbooks/test_git")
      assert File.exist?("cookbooks/test_git/.git")
    end
  end
end
