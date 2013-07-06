require 'spec_helper'
describe Gemrat do
  before do
    test_gemfile = File.new("TestGemfile", "w")
    test_gemfile.write ("https://rubygems.org'\n\n# Specify your gem's dependencies in gemrat.gemspec\ngem 'rspec', '2.13.0'\n")
    test_gemfile.close


    class Gemrat::Gem
      def stubbed_response
        File.read("./spec/resources/rubygems_response_shim_for_#{name}")
      rescue Errno::ENOENT
        ""
      end
      alias_method :fetch_all, :stubbed_response
    end

    class Gemrat::Runner
      def stub_bundle
        puts "Bundling...".green
      end
      alias_method :run_bundle, :stub_bundle
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

  context "when valid arguments are given" do
    context "for one gem" do
      let(:output) { capture_stdout { Gemrat::Runner.run("sinatra", "-g", "TestGemfile") }}

      it "adds latest gem version to gemfile" do
        output.should include("'sinatra', '1.4.3' added to your Gemfile")
        gemfile_contents = File.open('TestGemfile', 'r').read
        gemfile_contents.should include("gem 'sinatra', '1.4.3'")
      end

      it "runs bundle install" do
        output.should include("Bundling")
      end

      # Tests for sqlite3 and s3 bugs
      context "when the gem ends in a number" do
        let!(:output) { capture_stdout { Gemrat::Runner.run("sqlite3", "-g", "TestGemfile") }}

        it "should parse the gem correctly" do
          output.should include("gem 'sqlite3', '1.3.7' added to your Gemfile.")
          output.should_not include("gem 'sqlite3', '30.3.12' added to your Gemfile.")
        end

        it "should add the gem to the gemfile correctly" do
          File.read("TestGemfile").should match(/sqlite3.+1\.3\.7/)
          File.read("TestGemfile").should_not match(/sqlite3.+3'\.3\.12/)
        end
      end

      context "when the --no-install flag is given" do
        let(:output) { capture_stdout { Gemrat::Runner.run("sinatra", "-g", "TestGemfile", "--no-install") }}
        it "adds latest gem version to gemfile" do
          output.should include("'sinatra', '1.4.3' added to your Gemfile")
          gemfile_contents = File.open('TestGemfile', 'r').read
          gemfile_contents.should include("gem 'sinatra', '1.4.3'")
        end

        it "does not run bundle install" do
          output.should_not include("Bundling")
        end
      end

      context "when the --no-version flag is given" do
        let(:output) { capture_stdout { Gemrat::Runner.run("sinatra", "-g", "TestGemfile", "--no-version") }}
        it "adds the gem without the version" do
          output.should include("'sinatra' added to your Gemfile")
          gemfile_contents = File.open('TestGemfile', 'r').read
          gemfile_contents.should =~ /gem 'sinatra'$/
        end

        it "runs bundle install" do
          output.should include("Bundling")
        end

        ["when the --optimistic flag is given with the --no-version flag", "--optimistic",
         "when the --pessimistic flag is given with the --no-version flag", "--pessimistic"].each_slice(2) do |ctx, flag|
          context ctx do
            let(:output) { capture_stdout { Gemrat::Runner.run("sinatra", "-g", "TestGemfile", "--no-version", flag) }}
            it "should raise Invalid Flags error" do
              output.should include(Gemrat::Messages::INVALID_FLAGS)
            end
          end
        end
      end

      ["when the --optimistic flag is given", "--optimistic", ">=",
       "when the --pessimistic flag is given", "--pessimistic", "~>",
       "when the -o flag is given", "-o", ">=",
       "when the -p flag is given", "-p", "~>"].each_slice(3) do |ctx, flag, constraint|
        context ctx do
          let(:output) { capture_stdout { Gemrat::Runner.run("sinatra", "-g", "TestGemfile", flag) }}
          it "should add the gem with appropriate version constraint" do
            output.should include("gem 'sinatra', '#{constraint} 1.4.3'")
            gemfile_contents = File.open('TestGemfile', 'r').read
            gemfile_contents.should include("gem 'sinatra', '#{constraint} 1.4.3'")
          end
        end
       end

      pending "when the --environment or -e flag is given" do
        let(:output) { capture_stdout { Gemrat::Runner.run("sinatra", "-g", "TestGemfile", "--environment test") }}
        it "adds the gem to the specifiyed environment" do
          output.should include "'sinatra' added to test environment in your Gemfile"
          gemfile_contents = File.open('TestGemfile', 'r').read
          gemfile_contents.should include("group :test do")
          gemfile_contents.should include("gem 'sinatra', '1.4.3'")
        end
      end
    end

    context "for multiple gems" do
      let(:output) { capture_stdout { Gemrat::Runner.run("sinatra", "rails", "minitest", "-g", "TestGemfile") } }
      it "adds latest gem versions to the gemfile" do
        output.should include("'sinatra', '1.4.3' added to your Gemfile")
        output.should include("'minitest', '5.0.5' added to your Gemfile")
        output.should include("'rails', '3.2.13' added to your Gemfile")
        gemfile_contents = File.open('TestGemfile', 'r').read
        gemfile_contents.should include("\ngem 'sinatra', '1.4.3'")
        gemfile_contents.should include("\ngem 'minitest', '5.0.5'")
        gemfile_contents.should include("\ngem 'rails', '3.2.13'")
      end

      it "runs bundle install" do
        output.should include("Bundling")
      end

      context "when one of the gems is invalid" do
        let(:output)  { capture_stdout { Gemrat::Runner.run("sinatra", "beer_maker_2000", "minitest", "-g", "TestGemfile") } }

        it "adds valid gems to the gemfile" do
          output.should include("'sinatra', '1.4.3' added to your Gemfile")
          output.should include("'minitest', '5.0.5' added to your Gemfile")
          output.should include("#{Gemrat::Messages::GEM_NOT_FOUND % "beer_maker_2000"}")
        end

        it "runs bundle install" do
          output.should include("Bundling")
        end
      end
    end
  end

  ["when gem name is left out from the arguments", "",
   "when -h is given in the arguments", "-h",
   "when --help is given in the arguments", "--help"].each_slice(2) do |ctx, arg|
    context ctx do
      it "prints usage" do
        output = capture_stdout { Gemrat::Runner.run(arg == "" ? nil : arg) }
        output.should include(Gemrat::Messages::USAGE)
      end
    end
  end

  ["when -v is given in the arguments", "-v",
   "when --version is given in the arginemts", "--version"].each_slice(2) do |ctx, arg|
    context ctx do
      it "prints gemrat version" do
        output = capture_stdout { Gemrat::Runner.run(arg) }
        output.should include(Gemrat::VERSION)
      end
    end
  end

  context "when a non-existant flag is given in the arguments" do
    it "prints out the help message" do
      output = capture_stdout { Gemrat::Runner.run("--doesnt-exist") }
      output.should include(Gemrat::Messages::USAGE)
    end
  end

  context "when gem is not found" do
    before do
      Gemrat::Runner.stub(:gem) do
        gem = Gem.new
        gem.invalid!
      end
      @gem_name = "unexistent_gem"
    end

    let(:output) { capture_stdout { Gemrat::Runner.run(@gem_name) } }

    it "prints a nice error message" do
      output.should include("#{Gemrat::Messages::GEM_NOT_FOUND % @gem_name}")
    end

    it "skips bundle install" do
      output.should_not include("Bundling...")
    end
  end

  context "when gem already exists in a gemfile" do
    context "and the gem is the newest version" do
      before do
        test_gemfile = File.open("TestGemfile", "w")
        test_gemfile << %Q{https://rubygems.org'
                               # Specify your gem's dependencies in gemrat.gemspec
                               gem 'minitest', '5.0.5'}
        test_gemfile.close
      end

      let(:output) { capture_stdout { Gemrat::Runner.run("minitest", "-g", "TestGemfile")} }

      it "informs that the gem already exists" do
        output.should include("gem 'minitest' already exists")
      end

      it "skips bundle install" do
        output.should_not include("Bundling...")
      end
    end

    context "and there is a newer version" do
      before do
        test_gemfile = File.open("TestGemfile", "w")
        test_gemfile << %Q{https://rubygems.org'
                               # Specify your gem's dependencies in gemrat.gemspec
                               gem 'minitest', '5.0.4'}
        test_gemfile.close
      end

      context "and the update is rejected" do
        before do
          Gemrat::Gemfile.any_instance.stub(:input) { "no\n" }
        end

        let(:output) { capture_stdout { Gemrat::Runner.run("minitest", "-g", "TestGemfile")} }

        it "informs about the new gem version" do
          output.should include("there is a newer version of the gem")
        end

        it "doesn't add the new gem version in the gemfile" do
          File.read("TestGemfile").should_not match(/minitest.+5\.0\.5/)
        end

        it "leaves the old gem version in the gemfile" do
          File.read("TestGemfile").should match(/minitest.+5\.0\.4/)
        end

        it "skips bundle install" do
          output.should_not include("Bundling...")
        end
      end

      ["and the update is approved with inputing y", "y\n",
       "and the update is approved by pressing enter", "\n"].each_slice(2) do |ctx, arg|
        context ctx do
          before do
            Gemrat::Gemfile.any_instance.stub(:input) { arg }
          end

          let!(:output) { capture_stdout { Gemrat::Runner.run("minitest", "-g", "TestGemfile")} }

          it "asks if you want to add the newer gem" do
            output.should include("there is a newer version of the gem")
          end

          it "updates the gem version in the gemfile" do
            File.read("TestGemfile").should match(/minitest.+5\.0\.5/)
          end

          it "informs that the gem has been updated to the newest version" do
            output.should include("Updated 'minitest' to version '5.0.5'")
          end

          it "doesn't add gem twice in the gemfile" do
            File.open("TestGemfile").grep(/minitest/).count.should eq(1)
          end

          it "runs bundle install" do
            output.should include("Bundling...")
          end
        end
      end
    end

    context "and the gem doesn't have a version specified" do
      before do
        test_gemfile = File.open("TestGemfile", "w")
        test_gemfile << %Q{https://rubygems.org'
                           # Specify your gem's dependencies in gemrat.gemspec
                           gem 'minitest'}
        test_gemfile.close
      end

      let!(:output) { capture_stdout { Gemrat::Runner.run("minitest", "-g", "TestGemfile")} }

      it "informs that a gem already exists" do
        output.should include("gem 'minitest' already exists")
      end

      it "doesn't add the gem to the gemfile" do
        File.read("TestGemfile").should_not match(/minitest.+5\.0\.5/)
      end

      it "doesn't touch the old gem in the gemfile" do
        File.read("TestGemfile").should match(/minitest.$/)
      end
    end

    context "the gem doesn't have a version specified and is mentioned in the comments (turbolinks issue)" do
      before do
        test_gemfile = File.open("TestGemfile", "w")
        test_gemfile << %Q{https://rubygems.org'
                               # Specify your gem's dependencies in gemrat.gemspec
                               # Read more: https://github.com/rails/turbolinks
                               gem 'turbolinks'}
        test_gemfile.close
      end

      let!(:output) { capture_stdout { Gemrat::Runner.run("turbolinks", "-g", "TestGemfile") }}
      it "should not prompt for a replacement" do
        output.should_not include("there is a newer version of the gem")
      end

      it "should notify you that the gem already exists and abort" do
        output.should include("gem 'turbolinks' already exists in your Gemfile. Skipping...")
      end

      it "doesn't add the gem to the gemfile" do
        File.read("TestGemfile").should_not match(/turbolinks.+1\.2\.0/)
      end
    end
  end
end
