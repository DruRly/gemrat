module Gemrat
  class Arguments
    ATTRIBUTES = [:gem_name, :gemfile]

    ATTRIBUTES.each { |arg| attr_accessor arg }


    def initialize(*args)
      self.arguments = *args

      self.gem_name  = arguments.first
      self.gemfile   = arguments.last || "Gemfile"
    end

    private

      attr_accessor :arguments
  end
end
