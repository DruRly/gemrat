module Gemrat
  class Gemfile
    class DuplicateGemFound < StandardError; end

    attr_accessor :needs_bundle
    alias_method :needs_bundle?, :needs_bundle

    def initialize(path)
      self.path         = path
      self.needs_bundle = false
    end

    def add(gem)
      file = File.open(path, "a+")

      check(gem, file)

      if gem.add?
        file.write "\n#{gem}"
        puts "#{gem} added to your Gemfile.".green

        needs_bundle!
      elsif gem.update?
        contents = File.read(path)
        File.open(path,'w') do |f|
          f.print contents.gsub(/^.*#{gem.name}.*$/, "#{gem}")

          f.close
        end
        puts "Updated '#{gem.name}' to version '#{gem.version}'.".green
        needs_bundle!
      elsif gem.no_version?
        file.write "\ngem '#{gem.name}'"

        puts "gem '#{gem.name}' added to your Gemfile.".green

        needs_bundle!
      end
    ensure
      file.close
    end

    private
      attr_accessor :path

      def needs_bundle!
        self.needs_bundle = true
      end

      def check(gem, file)
        grep_file = file.grep(/gem ("|')#{gem.name}("|'), ("|')#{gem.version}("|')/ )
        raise DuplicateGemFound unless grep_file.empty?
        current_gem_version = get_current_gem_version(gem, file)

        return unless current_gem_version =~ /\S/

        if current_gem_version < gem.version
          prompt_gem_replacement(gem, current_gem_version)
        end
      end

      def prompt_gem_replacement(gem, gem_version)
        print (Messages::NEWER_GEM_FOUND % [gem.name, gem.version, gem_version]).chomp + " "
        case input
        when /n|no/
          gem.skip!
        else
          gem.update!
        end
      end

      def get_current_gem_version(gem, file)
        file.rewind
        gem_version = file.grep(/gem ("|')#{gem.name}("|')[\W\d]+/)
        gem_version = gem_version.to_s.gsub(/[^\d|.]+/, '')
        gem_version
      end

      def input
        STDIN.gets
      end
  end
end
