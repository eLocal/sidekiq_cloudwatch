require 'sidekiq_cloudwatch/configuration'
require 'sidekiq_cloudwatch/metric_field'
require 'sidekiq_cloudwatch/put_metrics'
require 'sidekiq_cloudwatch/version'
require 'sidekiq/api'
require 'aws-sdk-cloudwatch'

module SidekiqCloudwatch
  DEFAULT_METRICS = [
    MetricField.new('Scheduled Size', :scheduled_size),
    MetricField.new('Retry Size', :retry_size),
    MetricField.new('Dead Size', :dead_size),
    MetricField.new('Processes Size', :processes_size),
    MetricField.new('Default Queue Latency', :default_queue_latency, unit: 'Seconds'),
    MetricField.new('Worker Size', :workers_size),
    MetricField.new('Enqueued', :enqueued)
  ].freeze

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.put_metrics
    PutMetrics.new(configuration).perform
  end
end
