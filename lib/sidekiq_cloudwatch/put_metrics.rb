module SidekiqCloudwatch
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
end
