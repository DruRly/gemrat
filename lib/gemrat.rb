require "gemrat/version"
require "colored"

module Gemrat
  class GemNotFound < StandardError; end

  def add_gem(name, gemfile='Gemfile')
    raise ArgumentError if name.nil?

    gem     = process name
    gemfile = File.open(gemfile, 'a')
    gemfile << "\n#{gem}"
    gemfile.close
    puts "#{gem} added to your Gemfile.".green
  end

  private

    def normalize_for_gemfile(rubygems_format)
      gem_name = rubygems_format.split.first
      normalized = ("gem " + rubygems_format).gsub(/[()]/, "'")
      normalized.gsub(/#{gem_name}/, "'#{gem_name}',")
    end

    def find_exact_match(name)
      find_all(name).reject { |n| /^#{name} / !~ n }.first
    end

    def find_all(name)
      fetch_all(name).split(/\n/)
    end

    def fetch_all(name)
      `gem search -r #{name}`
    end

    def process(name)
      exact_match   = find_exact_match name 

      raise GemNotFound if exact_match.nil?

      normalize_for_gemfile exact_match
    end

  public

  def usage
    usage = <<-USAGE

Gemrat

Add gems to Gemfile from the command line.

Usage: gemrat GEM_NAME

    USAGE
  end

  def gem_not_found(name)
    message = <<-MESSAGE

Unable to find gem '#{name}' on Rubygems. Sorry about that.
    MESSAGE
  end
end
