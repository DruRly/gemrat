require 'spec_helper'
describe Gemrat do
  before do
    test_gemfile = File.new("TestGemfile", "w")
    test_gemfile.puts ("https://rubygems.org'\n\n# Specify your gem's dependencies in gemrat.gemspec\ngem 'rspec', '2.13.0'\n")
    test_gemfile.close
  end

  after do
    File.delete("TestGemfile")
  end

  it "example" do
    `gemrat sinatra`
    gemfile_contents = File.open('TestGemfile').read
    gemfile_contents.should include("gem 'sinatra', '1.4.2'")
  end
end
