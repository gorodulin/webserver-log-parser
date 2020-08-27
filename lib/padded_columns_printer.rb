# frozen_string_literal: true

class PaddedColumnsPrinter

  class FormattedReport

    include Enumerable

    attr_reader :formatter
    attr_reader :report
    attr_reader :widths

    def initialize(report, widths, formatter)
      @formatter = formatter
      @report = report
      @widths = widths
    end

    def each
      report.each do |record|
        yield formatter.call(record, widths) % record
      end
    end

  end # ... FormattedReport

  DEFAULT_FORMATTER = ->(_record, _widths) { "%{path}%{count}" }

  attr_reader :formatter

  # Formatter must be a callable that takes a hash containing column widths as an argument
  def initialize(formatter: DEFAULT_FORMATTER)
    fail ArgumentError, "Expect formatter to be callable" unless formatter.respond_to?(:call)

    @formatter = formatter
  end

  # @return an iterable object that produces formatted lines
  def call(report)
    widths = calculate_column_widths(report)
    FormattedReport.new(report, widths, formatter)
  end

  # @return [Hash]
  private def calculate_column_widths(report)
    widths = Hash.new(0)
    report.each do |record|
      record.each do |column, value|
        widths[column] = [widths[column], value.to_s.length].max
      end
    end
    widths
  end

end
