require "ostruct"
module Gemrat
  class Gem
    class NotFound < StandardError; end

    attr_accessor :name, :valid, :action
    alias_method :valid?, :valid

    ACTIONS = OpenStruct.new({:add => "add", :update => "update", :skip => "skip"})

    def initialize
      self.valid = true
      
      add!
    end

    def to_s
      @normalized_name ||= normalize_name
    end

    def invalid!
      self.valid = false 
    end

    def version
      normalize_name.gsub(/[^\d|.]/, '')
    end

    def update!
      self.action = ACTIONS.update
    end

    def update?
      self.action == ACTIONS.update
    end

    def skip!
      self.action = ACTIONS.skip
    end

    def skip?
      self.action == ACTIONS.skip
    end
    
    def add!
      self.action = ACTIONS.add
    end

    def add?
      self.action == ACTIONS.add
    end

    private
      def normalize_name
        normalized = ("gem " + find_exact_match).gsub(/[()]/, "'")
        normalized.gsub(/#{name}/, "'#{name}',")
      end

      def find_exact_match
        find_all.reject do |n|
          /^#{name} / !~ n 
        end.first || raise(NotFound)
      end

      def find_all
        fetch_all.split(/\n/)
      end

      def fetch_all
        `gem search -r #{name}`
      end
  end
end
