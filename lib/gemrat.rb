require "gemrat/version"
require "gemrat/messages"
require "gemrat/runner"
require "gemrat/arguments"
require "colored"

module Gemrat
  class GemNotFound < StandardError; end
  class Gem < Struct.new(:name, :valid)
    alias_method :valid?, :valid

    def initialize(*args)
      super
      self.valid = true
    end

    def invalid!
      self.valid = false
    end
  end
end
