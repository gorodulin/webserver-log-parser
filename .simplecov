# frozen_string_literal: true

# Read more about SimpleCov (Code coverage for Ruby):
# @see https://github.com/colszowka/simplecov

require "simplecov-csv"

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new \
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CSVFormatter,
  ]

SimpleCov.minimum_coverage 50
SimpleCov.maximum_coverage_drop 1

SimpleCov.start do
  # Exclude from analysis:
  add_filter "/boot/"
  add_filter "/spec/"

  # Don't analyze small files:
  add_filter do |source_file|
    source_file.lines.count < 10
  end
end
