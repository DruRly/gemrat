module Gemrat
  class Gemfile
    class DuplicateGemFound < StandardError; end
    def initialize(path)
      self.path = path
    end

    def add(gem)
      file = File.open(path, "a+")

      check(gem, file)

      file << "\n#{gem}"
      puts "#{gem} added to your Gemfile.".green
    ensure
      file.close
    end

    private
      attr_accessor :path

      def check(gem, file)
        grep_file = file.grep(/gem ("|')#{gem.name}("|'), ("|')#{gem.version}("|')/ )
        raise DuplicateGemFound unless grep_file.empty?
        current_gem_version = grep_file.to_s.gsub(/[^\d|.]/, '')
      end

      def file_regexp
        Regexp.new("/gem (\"|')#{gem.name}(\"|')(|, (\"|')#{gem.version}(\"|'))/")
      end
  end
end
