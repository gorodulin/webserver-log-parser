#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../boot/env"

opts = Configurator.call(args: ARGV, is_tty: $stdin.tty?, scriptname: File.basename(__FILE__))

at_exit do
  $stdout.puts opts[:help] unless $!&.success?
end

exit(false) if opts[:action] == :help

case opts[:report]
when :unique
  output_format = ->(_record, widths) { "%-#{widths[:path] + 1}{path}%{count} unique visitors" }
  reporter = CountUniqueVisitors.new
when :total
  output_format = ->(_record, widths) { "%-#{widths[:path] + 1}{path}%{count} visits" }
  reporter = CountTotalVisits.new
end

begin
  report_builder = BuildReport.new \
    reporter: reporter,
    renderer: PaddedColumnsPrinter.new(formatter: output_format),
    on_parse_error: ->(line) { $stderr.puts "Can't parse:\n #{line}" }
  report_builder.call(opts[:source])
    .each do |line|
      $stdout.puts line
    end
  exit(true)
rescue SystemCallError => e
  $stderr.puts "Error: " + e.message[/(.*) @/, 1]
  exit(false)
end
