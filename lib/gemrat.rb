require "gemrat/version"
require "gemrat/messages"
require "gemrat/runner"
require "gemrat/arguments"
require "gemrat/gem"
require "colored"

module Gemrat
  class GemNotFound < StandardError; end
end
