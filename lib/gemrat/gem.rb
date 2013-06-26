module Gemrat
  class Gem
    class NotFound < StandardError; end

    attr_accessor :name, :valid
    alias_method :valid?, :valid

    def initialize
      self.valid = true
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
