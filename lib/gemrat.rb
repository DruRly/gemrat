require "gemrat/version"

module Gemrat
  def fetch_gem name
    gems_response = `gem search -r #{name}`
    gems_array = gems_response.split(/\n/)
    match = gems_array.find { |n| /^#{name} / =~ n }
    gem = ("gem " + match).gsub(/[()]/, "'")
    gem.gsub(/#{name}/, "'#{name}',")
  end

  def add_gem name
    gem = fetch_gem name
    gemfile = File.open('Gemfile', 'a')
    gemfile << "\n#{gem}"
    gemfile.close
  end
end
