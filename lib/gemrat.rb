require "gemrat/version"
require "colored"

module Gemrat
  def fetch_gem name
    gems_response = `gem search -r #{name}`
    gems_array = gems_response.split(/\n/)
    match = gems_array.find { |n| /^#{name} / =~ n }
    gem = ("gem " + match).gsub(/[()]/, "'")
    gem.gsub(/#{name}/, "'#{name}',")
  end

  def add_gem(name, gemfile='Gemfile')
    raise ArgumentError unless name

    gem = fetch_gem name
    gemfile = File.open(gemfile, 'a')
    gemfile << "\n#{gem}"
    gemfile.close
    puts "#{gem} added to your Gemfile.".green
  end

  def usage
    usage = <<-USAGE

Gemrat

Add gems to Gemfile from the command line.

Usage: gemrat GEM_NAME

    USAGE
  end
end
