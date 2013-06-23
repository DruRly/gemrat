module Gemrat
  class Gemfile
    def initialize(path)
      self.path = path
    end

    def add(gem)
      file = File.open(path, "a")
      file << "\n#{gem}"
      file.close
      puts "#{gem} added to your Gemfile.".green
    end

    private
      attr_accessor :path
  end
end
