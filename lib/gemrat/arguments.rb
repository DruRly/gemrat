module Gemrat
  class Arguments
    ATTRIBUTES = [:gem_names, :gemfile]

    ATTRIBUTES.each { |arg| attr_accessor arg }


    def initialize(*args)
      self.arguments = *args

      options  = arguments - gem_names
      opts     = Hash[*options]

      self.gemfile  = opts.delete("-g") || opts.delete("--gemfile") || "Gemfile"
    end

    def gem_names
      arguments.take_while { |arg| arg !~ /^-|^--/}
    end

    private

      attr_accessor :arguments

  end
end
