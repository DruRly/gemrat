require 'spec_helper'
describe Gemrat do
  before do
    test_gemfile = File.new("TestGemfile", "w")
    test_gemfile.write ("https://rubygems.org'\n\n# Specify your gem's dependencies in gemrat.gemspec\ngem 'rspec', '2.13.0'\n")
    test_gemfile.close

    class DummyClass
      include Gemrat
    end

    @dummy_class = DummyClass.new
  end

  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end

  after do
    File.delete("TestGemfile")
  end

  describe "#add_gem" do
    it "adds lastest gem version to gemfile" do
      output  = capture_stdout { @dummy_class.add_gem("sinatra", "TestGemfile") }
      output.should include("'sinatra', '1.4.3' added to your Gemfile")
      gemfile_contents = File.open('TestGemfile', 'r').read
      gemfile_contents.should include("\ngem 'sinatra', '1.4.3'")
    end

    context "when name is not given in arguments" do
      it "should raise ArgumentError" do
        expect { @dummy_class.add_gem }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#fetch_gem" do
    it "returns latest version of gem" do
      @dummy_class.fetch_gem("sinatra").should == "gem 'sinatra', '1.4.3'"
    end

    context "when gem is not found" do
      it "raises GemNotFound" do
        expect do
          @dummy_class.fetch_gem("no_one_would_name_a_gem_like_this_me_thinks")
        end.to raise_error(Gemrat::GemNotFound)
      end
    end
  end
end
