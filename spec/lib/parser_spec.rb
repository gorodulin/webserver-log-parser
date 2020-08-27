# frozen_string_literal: true

require "open3"

RSpec.describe "parser shell script" do

  let(:logfile_path) { "spec/fixtures/webserver.log" }
  let(:total_visits_report) { File.read("spec/fixtures/total_visits_report.out") }
  let(:unique_visitors_report) { File.read("spec/fixtures/unique_visitors_report.out") }
  let(:script) { "lib/parser.rb " }

  def command(string, **args)
    Open3.capture3(string.strip, args)
  end

  it "shows help if no arguments provided" do
    expected = "Usage: parser.rb [options] [FILE]"
    out = `lib/parser.rb`
    expect(out).to include(expected)
    expect($CHILD_STATUS).not_to be_success
  end

  it "displays IO errors" do
    _out, err, result = command(script + "spec") # Argument is a directory
    expect(err).to match("Is a directory")
    expect(result).not_to be_success
  end

  describe "file input" do

    it "outputs total visits report" do
      out, err, result = command(script + "--report total " + logfile_path)
      expect(out).to eq(total_visits_report)
      expect(result).to be_success, err
    end

    it "outputs unique visitors report" do
      out, err, result = command(script + "--report unique " + logfile_path)
      expect(out).to eq(unique_visitors_report)
      expect(result).to be_success, err
    end

  end # ... describe

  describe "stdin input" do

    let(:payload) { File.read(logfile_path) }

    it "outputs total visits report" do
      out, err, result = command(script + "--report total", stdin_data: payload)
      expect(out).to eq(total_visits_report)
      expect(result).to be_success, err
    end

    it "outputs unique visitors report" do
      out, err, result = command(script + "--report unique", stdin_data: payload)
      expect(out).to eq(unique_visitors_report)
      expect(result).to be_success, err
    end

  end # ... describe

end
