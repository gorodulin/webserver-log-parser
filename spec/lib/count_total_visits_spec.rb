# frozen_string_literal: true

RSpec.describe CountTotalVisits do

  let(:instance) { described_class.new }

  describe "#add" do

    it "returns counter" do
      expect(instance.add({ "path" => "A", "ip" => "b" })).to eq(1)
      expect(instance.add({ "path" => "A", "ip" => "b" })).to eq(2)
    end

  end # ... describe

  describe "#report" do

    it "returns array of hashes" do
      10.times do
        instance.add({ "path" => "A", "ip" => "b" })
        instance.add({ "path" => "A", "ip" => "a" })
      end
      20.times do
        instance.add({ "path" => "B", "ip" => "b" })
        instance.add({ "path" => "B", "ip" => "a" })
      end
      # Order matters!
      expect(instance.report).to eq([{ path: "B", count: 40 }, { path: "A", count: 20 }])
    end

  end # ... describe

end
