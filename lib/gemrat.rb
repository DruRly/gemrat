require "gemrat/version"
require "gemrat/messages"
require "gemrat/runner"
require "gemrat/arguments"
require "gemrat/gem"
require "gemrat/gemfile"

require "ostruct"
require "colored"
require "rbconfig"

module Gemrat
  class GemNotFound < StandardError; end

  SYSTEM = RbConfig::CONFIG["host_os"]
end
