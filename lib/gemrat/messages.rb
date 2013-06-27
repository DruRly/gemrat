module Gemrat
  module Messages

    USAGE = <<-USAGE.gsub /^( +)(\w+|  -)/, '\2'

    Gemrat

    Add gems to Gemfile from the command line.

    Usage: gemrat [GEM_NAME] [OPTIONS]

    Options:

    USAGE

    GEM_NOT_FOUND = <<-GEM_NOT_FOUND.gsub /^( +)(\w+)/, '\2'

    Unable to find gem '%s' on Rubygems. Sorry about that.
    GEM_NOT_FOUND

    DUPLICATE_GEM_FOUND = <<-DUPLICATE_GEM_FOUND.gsub /^( +)(\w+)/, '\2'

    gem '%s' already exists in your Gemfile. Skipping...
    DUPLICATE_GEM_FOUND

    NEWER_GEM_FOUND = <<-NEWER_GEM_FOUND.gsub /^( +)(\w+)/, '\2'

    Gem '%s' already exists, but there is a newer version of the gem (v %s > v %s).
    Update version? (Y/n)
    NEWER_GEM_FOUND
  end
end
