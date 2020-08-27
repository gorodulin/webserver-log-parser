# frozen_string_literal: true

if ENV["RUBY_ENV"] == "test"
  require "pry"
  require "ori"
end

# Autoload stuff

$: << File.expand_path("../lib", __dir__)

autoload :BuildReport,            "build_report.rb"
autoload :Configurator,           "configurator.rb"
autoload :CountTotalVisits,       "count_total_visits.rb"
autoload :CountUniqueVisitors,    "count_unique_visitors.rb"
autoload :PaddedColumnsPrinter,   "padded_columns_printer.rb"
autoload :ParseLine,              "parse_line.rb"
