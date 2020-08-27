# frozen_string_literal: true

RSpec.describe CountUniqueVisitors do

  let(:instance) { described_class.new }

  describe "#add" do

    it "returns counter" do
      expect(instance.add({ "path" => "A", "ip" => "a" })).to eq(1)
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
        instance.add({ "path" => "B", "ip" => "c" })
      end
      # Order matters!
      expect(instance.report).to eq([{ path: "B", count: 3 }, { path: "A", count: 2 }])
    end

  end # ... describe

end
