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

  describe "#load" do

    it "loads report and returns self" do
      result = instance.load(report)
      expect(instance.report).to eq(report)
      expect(result).to eq(instance)
    end

  end # ... describe

  describe "#each" do

    it "returns Enumerable" do
      expect(instance.each).to be_a(Enumerable)
    end

  end

end
