require 'minitest/autorun'
require 'fileutils'

require 'berkshelf'
require 'monolith/locations/git'

class TestGitLocation < MiniTest::Test

  def setup
    # Path variables
    @test_cookbook = "test_cookbook"
    @test_base = File.expand_path('../tmp', __FILE__)
    @mock_cache = File.join(@test_base, 'cache', @test_cookbook)
    @mock_destination = File.join(@test_base, 'cloned', @test_cookbook)
    @mock_origin = 'user@example.com:some/repo'
    # Set up a repo to clone from rather than using the real berkshelf cache
    # dir.
    FileUtils.rm_rf(@test_base)
    FileUtils.mkdir_p(@mock_cache)
    Dir.chdir(@mock_cache) do
      %x|git init|
      %x|git remote add origin #{@mock_origin}|
    end
  end

  def teardown
    FileUtils.rm_rf(@test_base)
  end

  def test_install
    # Actually do the install
    location = Monolith::GitLocation.new(nil)
    location.stub(:cache_path, @mock_cache) do
      location.install(@mock_destination)
    end

    assert File.directory?(@mock_destination)
    assert File.directory?(File.join(@mock_destination, '.git'))
    assert_equal @mock_origin, location.send(:origin_url, @mock_destination)
  end
end
