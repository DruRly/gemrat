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
        raise DuplicateGemFound unless file.grep(/gem ("|')#{gem.name}("|')/ ).empty?
      end
  end
end
