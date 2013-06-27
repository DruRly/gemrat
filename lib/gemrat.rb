require "ostruct"
require "optparse"
require "pry"

require "gemrat/version"
require "gemrat/messages"
require "gemrat/runner"
require "gemrat/arguments"
require "gemrat/gem"
require "gemrat/gemfile"

require "colored"
require "rbconfig"

module Gemrat
  class GemNotFound < StandardError; end

  SYSTEM = RbConfig::CONFIG["host_os"]
end
