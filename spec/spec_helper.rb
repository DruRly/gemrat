require 'rubygems'
require 'bundler/setup'

require 'gemrat' # and any other gems you need
require 'pry'

RSpec.configure do |config|
  # some (optional) config here
end

module Kernel
  def silence_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    return result
  end
end
