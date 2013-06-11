require 'spec_helper'
describe Gemrat do
  before do
    test_gemfile = File.new("TestGemfile", "w")
    test_gemfile.write ("https://rubygems.org'\n\n# Specify your gem's dependencies in gemrat.gemspec\ngem 'rspec', '2.13.0'\n")
    test_gemfile.close

    class DummyClass
    end

    @dummy_class = DummyClass.new
    @dummy_class.extend(Gemrat)
  end

  after do
    File.delete("TestGemfile")
  end

  describe "#add_gem" do
    it "adds lastest gem version to gemfile" do
      @dummy_class.add_gem("sinatra", "TestGemfile").should == "gem 'sinatra', '1.4.3' added."
      gemfile_contents = File.open('TestGemfile', 'r').read
      gemfile_contents.should include("\ngem 'sinatra', '1.4.3'")
    end
  end

  describe "#fetch_gem" do
    it "returns latest version of gem" do
      @dummy_class.fetch_gem("sinatra").should == "gem 'sinatra', '1.4.3'"
    end
  end
end
