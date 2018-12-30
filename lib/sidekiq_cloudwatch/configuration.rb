# frozen_string_literal: true

module SidekiqCloudwatch
  class Configuration
    attr_writer :metric_fields, :namespace, :aws_client_options

    def metric_fields
      @metric_fields ||= DEFAULT_METRICS
    end

    def aws_client_options
      @aws_client_options ||= { region: 'us-east-1' }
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
end
