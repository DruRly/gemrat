require 'spec_helper'
describe Gemrat::Gem do
  before do
    class Gemrat::Gem
      def stubbed_response
        File.read("./spec/resources/rubygems_response_shim_for_#{name}")
      rescue Errno::ENOENT
        ""
      end
      alias_method :fetch_all, :stubbed_response
    end
  end

  let(:subject) { Gemrat::Gem.new }

  context "when gem is platform dependent" do
    before { subject.name = "thin" }

    it { should be_platform_dependent }

    context "for linux" do
      before do
        Kernel.silence_warnings { Gemrat.const_set("SYSTEM", "gnu-linux") }
      end

      it "returns correct version" do
        subject.to_s.should == "gem 'thin', '1.5.1'"
      end
    end

    context "for windows" do
      before do
        Kernel.silence_warnings { Gemrat.const_set("SYSTEM", "x86-mingw32") }
      end

      it "returns correct version" do
        puts subject.to_s
        subject.to_s.should == "gem 'thin', '1.2.11'"
      end
    end
  end
end
