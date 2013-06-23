module Gemrat
  class Arguments
    ATTRIBUTES = [:gems, :gemfile]

    ATTRIBUTES.each { |arg| attr_accessor arg }


    def initialize(*args)
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
        raise ArgumentError if invalid?
      end

      def invalid?
        gem_names.empty? || gem_names.first =~ /-h|--help/ || gem_names.first.nil?
      end

      def extract_options
        options  = arguments - gem_names
        opts     = Hash[*options]

        self.gemfile  = opts.delete("-g") || opts.delete("--gemfile") || "Gemfile"
      rescue ArgumentError
        # unable to extract options, leave them nil
      end

      def gem_names
        arguments.take_while { |arg| arg !~ /^-|^--/}
      end
  end
end
