module Gemrat
  class Arguments
    ATTRIBUTES = [:gem_names, :gemfile]

    ATTRIBUTES.each { |arg| attr_accessor arg }


    def initialize(*args)
      self.arguments = *args

      validate

      extract_options
    end

    def gem_names
      arguments.take_while { |arg| arg !~ /^-|^--/}
    end

    private

      attr_accessor :arguments

      def validate
        raise ArgumentError if gem_names.empty? || gem_names.first =~ /-h|--help/
      end

      def extract_options
        options  = arguments - gem_names
        opts     = Hash[*options]

        self.gemfile  = opts.delete("-g") || opts.delete("--gemfile") || "Gemfile"
      rescue ArgumentError
        # unable to extract options, leave them nil
      end
  end
end
