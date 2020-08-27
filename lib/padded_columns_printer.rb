# frozen_string_literal: true

class PaddedColumnsPrinter

  include Enumerable

  DEFAULT_FORMATTER = ->(_record, _widths) { "%{path}%{count}" }

  attr_reader :formatter
  attr_reader :report
  attr_reader :widths

  # Formatter must be a callable that takes a hash containing column widths as an argument
  def initialize(formatter: DEFAULT_FORMATTER)
    fail ArgumentError, "Expect formatter to be callable" unless formatter.respond_to?(:call)
    @formatter = formatter
    load({})
  end

  def load(report)
    @report = report
    @widths = calculate_column_widths(report)
    self
  end

  def each
    report.each do |record|
      yield formatter.call(record, widths) % record
    end
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
