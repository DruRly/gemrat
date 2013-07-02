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
        with_error_handling { gemfile.add(gem) }
      end

      run_bundle unless skip_bundle?
    end

    attr_accessor :gem

    private

      attr_accessor :gems, :gemfile, :no_install, :no_version, :version_constraint

      def parse_arguments(*args)
        Arguments.new(*args).tap do |a|
          self.gems      = a.gems
          self.gemfile   = a.gemfile
          self.no_install = a.options.no_install
          self.no_version = a.options.no_version
          self.version_constraint = a.options.version_constraint
        end
      end

      def with_error_handling
        yield
      rescue Arguments::PrintHelp
      rescue Gem::NotFound
        puts Messages::GEM_NOT_FOUND.red % gem.name
        gem.invalid!
      rescue Gemfile::DuplicateGemFound
        puts Messages::DUPLICATE_GEM_FOUND % gem.name
        gem.invalid!
      end

      def for_each_gem
        gems && gems.each do |gem|
          set_no_version(gem)
          set_version_constraint(gem)
          self.gem = gem
          yield
        end
      end

      def set_version_constraint(gem)
        gem.version_constraint = version_constraint
      end

      def set_no_version(gem)
        if no_version
          gem.no_version!
        end
      end

      def skip_bundle?
        gems.nil? ||
        gems.empty? ||
        gems.select(&:valid?).empty? ||
        !gemfile.needs_bundle? ||
        no_install
      end

      def run_bundle
        puts "Bundling...".green
        `bundle`
      end
  end
end
