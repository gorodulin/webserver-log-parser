# frozen_string_literal: true

RSpec.describe PaddedColumnsPrinter do

  let(:report) do
    [
      { path: "a" * 8, count: "0" * 14 },
      { path: "b" * 9, count: "0" * 19 },
    ]
  end
  let(:formatter) { ->(_record, widths) { "%-#{widths[:path] + 1}{path}%{count}" } }
  let(:instance) { described_class.new(formatter: formatter) }

  describe "#formatter" do

    it "returns formatter" do
      expect(instance.formatter).to eq(formatter)
    end

  end # ... describe

  describe "#call" do

    it "returns iterator that produces formatted report" do
      result = instance.call(report)
      expect(result).to respond_to(:each)
      result_as_text = result.to_a.join("\n")
      expected = "aaaaaaaa  00000000000000\nbbbbbbbbb 0000000000000000000"
      expect(result_as_text).to eq(expected)
    end

  end # ... describe

end
