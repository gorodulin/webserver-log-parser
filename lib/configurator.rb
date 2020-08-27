# frozen_string_literal: true

require "optparse"

class Configurator

  def self.call(args:, is_tty:, scriptname:)
    result = { report: :total, source: nil, action: :parse } # Defaults

    options_parser = OptionParser.new do |opts|

      opts.banner = "Usage: #{scriptname} [options] [FILE]"

      # TODO: report options should be configurable via arguments
      opts.on("--report TYPE", String, %i[unique total], "Select report type (unique, total)") do |kind|
        result[:report] = kind
      end

      opts.on("-h", "--help", "Prints this help") do
        result[:action] = :help
      end

      result[:help] = opts.to_s

    end

    options_parser.parse!(args)

    if args.size == 1
      result[:source] = File.foreach(args[0])
    elsif !is_tty
      result[:source] = $stdin
    else
      result[:action] = :help
    end

    result
  end

end
