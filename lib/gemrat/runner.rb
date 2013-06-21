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

          find_exact_match
          ensure_gem_exists
          normalize_for_gemfile
          add_to_gemfile

        end
      end

      run_bundle unless gems.nil? || gems.empty? || gems.select(&:valid?).empty?
    end

    attr_accessor :gem

    private
    
      attr_accessor :gems, :gemfile, :exact_match

      def parse_arguments(*args)
        Arguments.new(*args).tap do |a|
          self.gems      = a.gem_names.map {|name| Gem.new(name) }
          self.gemfile   = a.gemfile
        end
      end

      def with_error_handling
        yield
      rescue ArgumentError
        puts Messages::USAGE
      rescue GemNotFound
        puts Messages::GEM_NOT_FOUND.red % gem.name
        gem.invalid!
      end

      def for_each_gem
        gems && gems.each do |gem|
          self.gem = gem
          yield
        end
      end

      def find_exact_match
        self.exact_match = find_all(gem.name).reject { |n| /^#{gem.name} / !~ n }.first
      end

      def find_all(name)
        fetch_all(name).split(/\n/)
      end

      def fetch_all(name)
        `gem search -r #{name}`
      end

      def ensure_gem_exists
        raise GemNotFound if exact_match.nil?
      end

      def normalize_for_gemfile
        gem_name = exact_match.split.first
        normalized = ("gem " + exact_match).gsub(/[()]/, "'")
        self.gem.name = normalized.gsub(/#{gem_name}/, "'#{gem_name}',")
      end

      def add_to_gemfile
        new_gemfile = File.open(gemfile, 'a')
        new_gemfile << "\n#{gem.name}"
        new_gemfile.close
        puts "#{gem.name} added to your Gemfile.".green
      end

      def run_bundle
        puts "Bundling...".green
        `bundle`
      end
  end
end
