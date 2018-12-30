# frozen_string_literal: true

module SidekiqCloudwatch
  class MetricField
    attr_reader :name, :unit, :operation

    def initialize(name, operation, unit: 'Count')
      @name = name
      @operation = operation
      @unit = unit
    end
  end
end
