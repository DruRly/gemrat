module Gemrat
  class Arguments
    class UnableToParse < StandardError; end

    ATTRIBUTES = [:gems, :gemfile, :replace_gem]

    ATTRIBUTES.each { |arg| attr_accessor arg }


    def initialize(*args)
      self.replace_gem = true
      self.arguments = *args

      validate

      extract_options
    end


    def gems
      gem_names.map do |name|
        gem      = Gem.new
        gem.name = name
        gem
      end
    end

    private

      attr_accessor :arguments

      def validate
        raise UnableToParse if invalid?
      end

      def invalid?
        gem_names.empty? || gem_names.first =~ /-h|--help/ || gem_names.first.nil?
      end

      def extract_options
        options  = arguments - gem_names
        opts     = Hash[*options]

        self.gemfile  = Gemfile.new(opts.delete("-g") || opts.delete("--gemfile") || "Gemfile")
      rescue ArgumentError
        raise UnableToParse
        # unable to extract options, leave them nil
      end

      def gem_names
        arguments.take_while { |arg| arg !~ /^-|^--/}
      end
  end
end
