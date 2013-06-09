require "gemrat/version"

module Gemrat
  def fetch_gem name
    gems_response = `gem search -r #{name}`
    gems_array = gems_response.split(/\n/)
    match = gems_array.find { |n| /^#{name} / =~ n }
    gem = ("gem " + match).gsub(/[()]/, "'")
    gem.gsub(/#{name}/, "'#{name}',")
  end

  def convert_gem name_version
    name_version
  end

  def add_gem name
    #Fetch gem
    #Open gemfile
    #Add gem
  end
end
