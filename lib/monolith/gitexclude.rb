module Monolith
  class GitExclude
    def initialize(git_dir, options)
      @lines_to_add = []
      @lines_to_remove = []
      @git_dir = Pathname.new(git_dir)
      @filename = @git_dir.join('info', 'exclude')
      @enabled = options[:git_exclude]
    end

    def relative_path(path)
      Pathname.new(path).relative_path_from(@git_dir.parent).to_s
    end

    def add(line)
      @lines_to_add << relative_path(line)
    end

    def remove(line)
      @lines_to_remove << relative_path(line)
    end

    def update
      return unless @enabled

      # We don't want to do anything if we're not actually in a git repo
      return unless File.directory?(@git_dir)

      if File.exist?(@filename)
        data = File.read(@filename).split("\n")
      else
        data = []
      end
      # Don't go creating a file if there's nothing to add and we're already
      # empty
      return if data.empty? and @lines_to_add.empty?

      # Now add/remove lines - additions first
      data.concat(@lines_to_add.reject { |l| data.include?(l) })
      data.reject! { |l| @lines_to_remove.include?(l) }

      # And write out the new file
      File.open(@filename, "w") do |file|
        data.each do |l|
          file.puts(l)
        end
      end

      # Reset the list of lines to add/remove
      @lines_to_add = []
      @lines_to_remove = []
    end
  end
end
