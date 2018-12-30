module SidekiqCloudwatch
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
end
