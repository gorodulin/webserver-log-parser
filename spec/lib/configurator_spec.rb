# frozen_string_literal: true

RSpec.describe Configurator do

  let(:report_args) do
    {
      "--report total filename.log" => { report: :total, action: :parse },
      "--report unique filename.log" => { report: :unique, action: :parse },
      "filename.log" => { report: :total, action: :parse },
      "--report unique" => { report: :unique, action: :help },
      "--report total" => { report: :total, action: :help },
    }
  end

  describe "::call" do

    it "parses --report argument" do
      report_args.each do |args, expected|
        result = described_class.call(args: args.split(" "), is_tty: true, scriptname: "parse.rb")
        expect(result).to include(expected)
      end
    end

    it "parses --help argument" do
      result = described_class.call(args: ["--help"], is_tty: true, scriptname: "parse.rb")
      expect(result).to include({ action: :help, source: nil })
    end

  end # ... Configurator

end
