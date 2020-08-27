# frozen_string_literal: true

RSpec.describe ParseLine do

  let(:valid_args) do
    {
      "/help_page/1  126.318.035.038\n"   => { "path" => "/help_page/1", "ip" => "126.318.035.038" },
      "/contact?a=b&c=d 184.123.665.067"  => { "path" => "/contact?a=b&c=d", "ip" => "184.123.665.067" },
      "/%0D%0C 184.123.665.067"           => { "path" => "/%0D%0C", "ip" => "184.123.665.067" },
      "/ 444.701.448.104"                 => { "path" => "/", "ip" => "444.701.448.104" },
      "/ 1.1.1.1"                         => { "path" => "/", "ip" => "1.1.1.1" },
    }
  end

  let(:invalid_args) do
    [
      "",
      " 126.318.035.038\n",
      " / 1.1.1.1",
      "x 1.1.1.1",
      "/ 1.1.1",
      "string 1",
    ]
  end

  describe "::call" do

    describe "valid payload" do

      it "returns hash with 'path' and 'ip' keys" do
        valid_args.each_pair do |line, expected|
          expect(described_class.call(line)).to eq(expected)
        end
      end

    end # ... describe

    describe "invalid payload" do

      it "returns nil" do
        invalid_args.each do |line|
          expect(described_class.call(line)).to be_nil
        end
      end

    end # ... describe

  end # ... describe

end
