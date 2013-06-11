# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemrat/version'

Gem::Specification.new do |spec|
  spec.name          = "gemrat"
  spec.version       = Gemrat::VERSION
  spec.authors       = ["Dru Riley"]
  spec.email         = ["dru@drurly.com"]
  spec.description   = "Add gems from the command line."
  spec.summary       = "Add gems from the command line."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end