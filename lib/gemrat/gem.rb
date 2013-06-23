module Gemrat
  class Gem

    attr_accessor :name, :valid
    alias_method :valid?, :valid

    def initialize
      self.valid = true
    end

    def invalid!
      self.valid = false
    end
  end
end
