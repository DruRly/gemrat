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
      parse_arguments(*args)
    end

    def run
      with_error_handling do

        validate_input

        find_exact_match
        ensure_gem_exists
        normalize_for_gemfile

        add_to_gemfile
        run_bundle

      end
    end

    private
    
      attr_accessor :gem_name, :gemfile, :exact_match

      def parse_arguments(*args)
        arguments = Arguments.new(*args)
        self.gem_name = arguments.gem_names.first
        self.gemfile  = arguments.gemfile
      end

      def with_error_handling
        yield
      rescue ArgumentError
        puts Messages::USAGE
      rescue GemNotFound
        puts Messages::GEM_NOT_FOUND.red % gem_name
      end

      def validate_input
        raise ArgumentError if gem_name.nil? || gem_name =~ /-h|--help/
      end

      def find_exact_match
        self.exact_match = find_all(gem_name).reject { |n| /^#{gem_name} / !~ n }.first
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
        self.gem_name = normalized.gsub(/#{gem_name}/, "'#{gem_name}',")
      end

      def add_to_gemfile
        new_gemfile = File.open(gemfile, 'a')
        new_gemfile << "\n#{gem_name}"
        new_gemfile.close
        puts "#{gem_name} added to your Gemfile.".green
      end

      def run_bundle
        puts "Bundling...".green
        `bundle`
      end
  end
end
