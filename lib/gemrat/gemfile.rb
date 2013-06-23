module Gemrat
  class Gemfile
    class DuplicateGemFound < StandardError; end
    def initialize(path)
      self.path = path
    end

    def add(gem)
      check(gem)

      file = File.open(path, "a")
      file << "\n#{gem}"
      file.close
      puts "#{gem} added to your Gemfile.".green
    end

    private
      attr_accessor :path

      def check(gem)
        raise DuplicateGemFound unless File.open(path) { |f| f.grep(/gem ("|')#{gem.name}("|')/ )}.empty?
      end
  end
end
