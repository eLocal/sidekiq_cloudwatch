require 'sidekiq_cloudwatch/version'
require 'sidekiq/api'
require 'aws-sdk-cloudwatch'

module SidekiqCloudwatch
  class MetricField
    attr_reader :name, :unit, :operation

    def initialize(name, operation, unit: 'Count')
      @name = name
      @operation = operation
      @unit = unit
    end
  end

  DEFAULT_METRICS = [
    MetricField.new('Scheduled Size', :scheduled_size),
    MetricField.new('Retry Size', :retry_size),
    MetricField.new('Dead Size', :dead_size),
    MetricField.new('Processes Size', :processes_size),
    MetricField.new('Default Queue Latency', :default_queue_latency, unit: 'Seconds'),
    MetricField.new('Worker Size', :workers_size),
    MetricField.new('Enqueued', :enqueued)
  ].freeze

  class Configuration
    attr_writer :metric_fields, :namespace

    def metric_fields
      @metric_fields ||= DEFAULT_METRICS
    end

    def namespace
      @namespace ||= 'Sidekiq'
    end

    def dimensions
      @dimensions ||= default_dimensions
    end

    def default_dimensions
      return [] unless Module.const_defined?('Rails')
      [
        { name: 'RailsEnv', value: Rails.env },
        { name: 'Application', value: Rails.application.class.to_s.split('::')[0..-2].join(' ') }
      ]
    end
  end

  class PutMetrics
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def perform
      Aws::CloudWatch::Client.new.put_metric_data(
        namespace: configuration.namespace,
        metric_data: metric_data
      )

      self
    end

    def metric_data
      @metric_data ||=
        metric_fields.map do |metric_field|
          {
            metric_name: metric_field.name, # required
            dimensions: configuration.dimensions,
            value: current_value(metric_field),
            unit: 'Count'
          }
        end
    end

    def current_value(metric_field)
      if metric_field.operation.respond_to?(:call)
        metric_field.operation.call
      else
        sidekiq_stats.send(metric_field.operation)
      end
    end

    def sidekiq_stats
      @sidekiq_stats ||= Sidekiq::Stats.new
    end

    def metric_fields
      configuration.metric_fields
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.put_metrics
    PutMetrics.new(configuration).perform
  end
end
