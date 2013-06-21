module Gemrat
  module Messages

    USAGE = <<-USAGE.gsub /^( +)(\w+|  -)/, '\2'

    Gemrat

    Add gems to Gemfile from the command line.

    Usage: gemrat [GEM_NAME] [OPTIONS]

    Options:

      -g [--gemfile]  # Specify the Gemfile to be used. Defaults to 'Gemfile'.
      -h [--help]     # Print these usage instructions.

    USAGE

    GEM_NOT_FOUND = <<-GEM_NOT_FOUND.gsub /^( +)(\w+)/, '\2'

    Unable to find gem '%s' on Rubygems. Sorry about that.
    GEM_NOT_FOUND

  end
end
