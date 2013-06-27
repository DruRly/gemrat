module Gemrat
  class Arguments
    class UnableToParse < StandardError; end

    ATTRIBUTES = [:gems, :gemfile, :options]

    ATTRIBUTES.each { |arg| attr_accessor arg }


    def initialize(*args)
      self.arguments = *args

      validate

      parse_options
      #extract_options
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

      def parse_options
        self.options = OpenStruct.new

        options.gemfile = "Gemfile"

        OptionParser.new do |opts|
          opts.on("-g", "--gemfile GEMFILE", "Specify the Gemfile to be used, defaults to 'Gemfile'") do |gemfile|
            options.gemfile = gemfile
          end
        end.parse!(arguments)
        self.gemfile = Gemfile.new(options.gemfile)
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
