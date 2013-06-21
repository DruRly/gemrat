module Gemrat
  module Messages

    USAGE = <<-USAGE.gsub /^( +)(\w+)/, '\2'

    Gemrat

    Add gems to Gemfile from the command line.

    Usage: gemrat GEM_NAME

    USAGE

    GEM_NOT_FOUND = <<-GEM_NOT_FOUND.gsub /^( +)(\w+)/, '\2'

    Unable to find gem '%s' on Rubygems. Sorry about that.
    GEM_NOT_FOUND

  end
end
