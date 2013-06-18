# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemrat/version'

Gem::Specification.new do |spec|
  spec.name          = "gemrat"
  spec.version       = Gemrat::VERSION
  spec.authors       = ["Dru Riley"]
  spec.email         = ["dru@drurly.com"]
  spec.description   = "Add the latest version of a gem to your Gemfile from the command line."
  spec.summary       = "Add the latest version of a gem to your Gemfile from the command line."
  spec.homepage      = "https://github.com/DruRly/gemrat"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "colored", "1.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
