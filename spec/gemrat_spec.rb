require 'spec_helper'
describe Gemrat do
  before do
    test_gemfile = File.new("TestGemfile", "w")
    test_gemfile.write ("https://rubygems.org'\n\n# Specify your gem's dependencies in gemrat.gemspec\ngem 'rspec', '2.13.0'\n")
    test_gemfile.close


    class Gemrat::Runner
      def stubbed_response(*args)
        File.read("./spec/resources/rubygems_response_shim")
      end
      alias_method :fetch_all, :stubbed_response
    end
  end

  after :each do
    Gemrat::Runner.instance = nil
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

  describe Gemrat::Runner do
    subject { Gemrat::Runner }
    describe "#run" do
      context "when valid arguments are given" do
        it "adds lastest gem version to gemfile" do
          output  = capture_stdout { subject.run("sinatra", "-g", "TestGemfile") }
          output.should include("'sinatra', '1.4.3' added to your Gemfile")
          gemfile_contents = File.open('TestGemfile', 'r').read
          gemfile_contents.should include("\ngem 'sinatra', '1.4.3'")
        end
      end

      ["when gem name is left out from the arguments",
       "when -h or --help is given in the arguments"].each do |ctx|
        context ctx do
          it "prints usage" do
            output = capture_stdout { subject.run }
            output.should include(Gemrat::Messages::USAGE)
          end
        end
      end

      context "when gem is not found" do
        before do
          subject.stub(:find_exact_match)
          @gem_name = "unexistent_gem"
        end

        it "prints a nice error message" do
          output = capture_stdout { subject.run(@gem_name) }
          output.should include("#{Gemrat::Messages::GEM_NOT_FOUND % @gem_name}")
        end
      end
    end
  end
end
