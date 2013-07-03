module Gemrat
  class Arguments
    class PrintHelp < StandardError; end

    ATTRIBUTES = [:gems, :gemfile, :options]

    ATTRIBUTES.each { |arg| attr_accessor arg }


    def initialize(*args)
      self.arguments = *args

      parse_options
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

      def validate(opt_parser)
        if gem_names.empty? || gem_names.first.nil?
          puts opt_parser.help
          raise PrintHelp
        end
      end

      def parse_options
        self.options = OpenStruct.new

        options.gemfile = "Gemfile"

        opt_parser = OptionParser.new do |opts|
          opts.banner = Messages::USAGE

          opts.on("-g", "--gemfile GEMFILE", "# Specify the Gemfile to be used, defaults to 'Gemfile'") do |gemfile|
            options.gemfile = gemfile
          end

          opts.on("--no-install", "# Skip executing bundle after adding the gem.") do
            options.no_install = true
          end

          opts.on("--no-version", "# Do not add a version to the gemfile.") do
            options.no_version = true
          end

          opts.on("-p", "--pessimistic", "# Add gem with a pessimistic operator (~>)") do
            options.version_constraint = "pessimistic"
          end

          opts.on("-o", "--optimistic", "# Add gem with an optimistic operator (>=)") do
            options.version_constraint = "optimistic"
          end

          opts.on_tail("-h", "--help", "# Print these usage instructions.") do
            puts opts
            raise PrintHelp
          end

          opts.on("-v", "--version", "# Show current gemrat version.") do
            puts Gemrat::VERSION
            raise PrintHelp
          end
        end

        begin
          opt_parser.parse!(arguments)
        rescue OptionParser::InvalidOption
          puts opt_parser
          raise PrintHelp
        end
        validate(opt_parser)

        self.gemfile = Gemfile.new(options.gemfile)
      end

      def gem_names
        arguments.take_while { |arg| arg !~ /^-|^--/}
      end
  end
end
