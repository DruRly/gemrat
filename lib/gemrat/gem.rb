module Gemrat
  class Gem
    class NotFound < StandardError; end
    class InvalidFlags < StandardError; end

    attr_accessor :name, :valid, :action, :version_constraint, :no_version
    alias_method :valid?, :valid

    ACTIONS = OpenStruct.new({:add => "add", :update => "update",
                              :skip => "skip"})

    def initialize
      self.valid = true

      add!
    end

    def to_s
      @output ||= get_output
    end

    def invalid!
      self.valid = false 
    end

    def version
      if platform_dependent?
        platform_dependent_version
      else
        standard_version
      end
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

    def no_version?
      no_version
    end

    def no_version!
      self.no_version = true
    end

    private

      def get_output
        if self.no_version? && self.version_constraint
          raise InvalidFlags
        end
        if self.no_version?
          return with_no_version
        elsif self.version_constraint
          return with_version_constraint
        else
          return "gem '#{name}', '#{version}'"
        end
      end

      def with_no_version
        "gem '#{name}'"
      end

      def with_version_constraint
        case self.version_constraint
        when "optimistic"
          "gem '#{name}', '>= #{version}'"
        when "pessimistic"
          "gem '#{name}', '~> #{version}'"
        end
      end

      def platform_dependent?
        versions.count > 1
      end

      def standard_version
        normalize_name.match(/\d[\d\.]+/).to_s
      end

      def versions
        platform_versions = normalize_name.gsub(/'/,"").split(",")[1..-1]

        hash = {:default => platform_versions.shift}

        platform_versions.inject(hash) do |hash, part|
          hash[part.split(" ")[1..-1]] = part.split(" ").first
          hash
        end
      end

      def platform_dependent_version
        version_for_platform = versions.select do |key, value|
          key.join =~ /#{SYSTEM}/ if key.is_a? Array
        end.values

        if version_for_platform.empty?
          versions[:default].strip
        else
          version_for_platform.first
        end
      end

      def normalize_name
        if no_version?
          normalized = ("gem '" + name + "'")
        else
          normalized = ("gem " + find_exact_match).gsub(/[()]/, "'")
          normalized.gsub(/#{name}/, "'#{name}',")
        end
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
