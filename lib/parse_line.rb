# frozen_string_literal: true

class ParseLine

  def self.call(string)
    string.match(%r{\A(?<path>\/[^ ]*)\s+(?<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})})&.named_captures
  end

end
