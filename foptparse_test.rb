require 'minitest/autorun'
require 'foptparse'

describe RubyLove::OptionParser do
  subject { RubyLove::OptionParser }

  describe "parse(text)" do
    describe "when given nada" do
      it "must display the default help" do
        subject.parse.must_equal [
          "This is the default help",
          "It will grow as options are added",
          []
        ]
      end
    end

    describe "when given valid arguments" do
      let(:args) { "-n bob -l 100 -v messages.csv" }
      it "must return [argument, options]" do
        subject.parse(args).must_equal(["messages.csv", ["-n", "bob", "-l", "100", "-v"]])
      end
    end
  end

  describe "extract_options" do
    let(:argv) { ["-n", "bob", "-l", "100", "-v"] }

    it "must extract flag/value pairs" do
      subject.send(:extract_options, argv).must_equal(
        [["-n", "bob"], ["-l", "100"], ["-v",nil]]
      )
    end
  end

  describe "split_argument_and_options(text)" do
    let(:args) { "-n bob -l 100 -v messages.csv" }

    it "must return arg and options as an array of 2" do
      subject.send(:split_argument_and_options, args).must_equal(
        ["messages.csv", ["-n", "bob", "-l", "100", "-v"]])
    end
  end

end
