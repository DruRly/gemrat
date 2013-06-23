module Gemrat
  class Runner
    class << self
      attr_accessor :instance

      def run(*args)
        @instance ||= new(*args)
        @instance.run
      end
    end

    include Gemrat
    include Messages

    def initialize(*args)
      with_error_handling { parse_arguments(*args) }
    end

    def run
      for_each_gem do
        with_error_handling do

          gemfile.add(gem)

        end
      end

      run_bundle unless gems.nil? || gems.empty? || gems.select(&:valid?).empty?
    end

    attr_accessor :gem

    private
    
      attr_accessor :gems, :gemfile

      def parse_arguments(*args)
        Arguments.new(*args).tap do |a|
          self.gems      = a.gems
          self.gemfile   = a.gemfile
        end
      end

      def with_error_handling
        yield
      rescue Arguments::UnableToParse
        puts Messages::USAGE
      rescue Gem::NotFound
        puts Messages::GEM_NOT_FOUND.red % gem.name
        gem.invalid!
      rescue Gemfile::DuplicateGemFound
        puts Messages::DUPLICATE_GEM_FOUND % gem.name
        gem.invalid!
      end

      def for_each_gem
        gems && gems.each do |gem|
          self.gem = gem
          yield
        end
      end

      def run_bundle
        puts "Bundling...".green
        `bundle`
      end
  end
end
