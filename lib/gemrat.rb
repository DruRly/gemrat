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
    if gem_exists?(gemfile, name)
      return puts '', '"%s" gem already exists in %s' % [name, gemfile], ''
    end
    gem = fetch_gem name
    gemfile = File.open(gemfile, 'a')
    gemfile << "\n#{gem}"
    gemfile.close
    puts "#{gem} added to your Gemfile.".green
    true
  end

  private
  def gem_exists? gemfile, gem
    existing_gems(gemfile).include? gem
  end

  def extract_gems gemfile
    File.read(gemfile).split("\n").inject([]) do |gems,l|
      l.strip!
      (l =~ /\Agem/) &&
        (gem = l.scan(/\Agem\s+([^,]*)/).flatten.first) &&
        (gems << gem.gsub(/\A\W+|\W+\Z/, ''))
      gems
    end
  end
  alias existing_gems extract_gems
end
