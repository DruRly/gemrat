require 'spec_helper'
describe Gemrat do
  before do
    test_gemfile = File.new("TestGemfile", "w")
    test_gemfile.puts ("https://rubygems.org'\n\n# Specify your gem's dependencies in gemrat.gemspec\ngem 'rspec', '2.13.0'\n")
    test_gemfile.close

    class DummyClass
    end

    @dummy_class = DummyClass.new
    @dummy_class.extend(Gemrat)
  end

  after do
    File.delete("TestGemfile")
  end

  it "adds the latest version of a gem to the file" do
    `gemrat sinatra`
    gemfile_contents = File.open('TestGemfile').read
    gemfile_contents.should include("gem 'sinatra', '1.4.2'")
  end

  it "returns a message if it can't find rubygems" do

  end

  describe "#fetch_gem" do
    it "returns latest version of gem" do
      @dummy_class.fetch_gem("sinatra").should == "gem 'sinatra', '1.4.3'"
    end
  end
end
