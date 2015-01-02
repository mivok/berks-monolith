require 'fileutils'
require 'pathname'

module Monolith
  module TestHelpers
    def tmp_path
      Pathname.new(File.expand_path("../tmp", __FILE__))
    end

    def clean_tmp_path
      FileUtils.rm_rf(tmp_path)
      FileUtils.mkdir_p(tmp_path)
    end

    def make_git_repo(name)
      # Makes an example git repo with a single file in and one commit
      repo_path = tmp_path.join("git", name)
      FileUtils.mkdir_p(repo_path)
      Dir.chdir(repo_path) do
        %x|git init|
        File.open('metadata.rb', 'w') do |f|
          f.puts "name '#{name}'"
        end
        %x|git add metadata.rb|
        %x|git config --local user.name Me|
        %x|git config --local user.email me@example.com|
        %x|git commit -m "Test commit"|
        %x|git remote add origin "git@git.example.com:#{name}"|
      end
      repo_path
    end

    def make_change_git(name)
      repo_path = tmp_path.join("git", name)
      Dir.chdir(repo_path) do
        File.open('test.txt', 'w') do |f|
          f.puts 'Testing'
        end
        %x|git add test.txt|
        %x|git commit --author "Me <me@example.com>" -m "Update"|
      end
    end

    def make_berksfile(types)
      File.open(tmp_path.join('Berksfile'), 'w') do |berksfile|
        berksfile.puts "source 'https://supermarket.chef.io/'"
        types.each do |type|
          if type == :git
            repo_path = make_git_repo('test_git')
            berksfile.puts("cookbook 'test_git', :git => '#{repo_path}'")
          end
        end
      end

      if block_given?
        Dir.chdir(tmp_path) do
          yield
        end
      end
    end
  end
end
