# frozen_string_literal: true

RSpec.describe BuildReport do

  let(:format_line) { ->(_record, widths) { "%-#{widths[:path] + 1}{path}%{count}" } }
  let(:reporter) { CountTotalVisits.new }
  let(:renderer) { PaddedColumnsPrinter.new(formatter: format_line) }
  let(:error_handler) { ->(_line) { "ERROR" } }
  let(:instance) do
    BuildReport.new \
      reporter: reporter,
      on_parse_error: error_handler,
      renderer: renderer
  end

  describe "attr_readers" do

    %i[line_parser on_parse_error reporter renderer].each do |attr|
      it "responds to ##{attr}" do
        expect(instance).to respond_to(attr)
      end
    end

  end # ... describe

  describe "#call" do

    describe "valid payload" do

      let(:payload) { ["/help_page/1 126.318.035.038"] }

      it "fills reporter with data" do
        expect(reporter).to receive(:add).with({ "ip" => "126.318.035.038", "path" => "/help_page/1" })
        instance.call(payload)
      end

      it "returns report" do
        result = instance.call(payload)
        expect(result).to respond_to(:each)
        expect(result.to_a).to eq(["/help_page/1 1"])
      end

    end # ... describe

    describe "invalid payload" do

      let(:payload) { ["help_page/1 126318.035.038"] }

      it "fills reporter with data" do
        expect(error_handler).to receive(:call).with(payload.first)
        instance.call(payload)
      end

      it "is not present in the output" do
        result = instance.call(payload)
        expect(result.to_a).to eq([])
      end

    end # ... describe

  end # ... describe

end
