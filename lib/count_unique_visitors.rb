# frozen_string_literal: true

require "set"

class CountUniqueVisitors

  def initialize
    @data = {}
  end

  def add(record)
    path, ip = record.values_at("path", "ip")
    @report = nil
    @data[path]&.add(ip) || @data[path] = ::Set.new([ip])
    @data[path].size
  end

  def report
    @report ||= @data
      .map { |k, v| [k, v.size] }
      .sort_by(&:last)
      .reverse
      .map { |k, v| { path: k, count: v } }
  end

end
