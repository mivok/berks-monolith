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

  def test_install_command
    make_berksfile([:git]) do
      Monolith::Command.start(['install', '-q'])
      assert File.exist?("cookbooks/test_git")
      assert File.exist?("cookbooks/test_git/.git")
    end
  end

  def test_nested_dependencies
    make_berksfile([:nested_community]) do
      Monolith::Command.start(['install', '-q'])
      assert File.exist?("cookbooks/test_nested")
      assert File.exist?("cookbooks/test_nested/metadata.rb")
      assert File.exist?("cookbooks/testmh")
    end
  end
end
