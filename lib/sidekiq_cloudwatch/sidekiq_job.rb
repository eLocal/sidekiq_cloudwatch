# frozen_string_literal: true

#
# Simple sidekiq job that can be used from sidekiq-cron
# to kick off a cloudwatch notification
#
require 'sidekiq_cloudwatch'

module SidekiqCloudwatch
  class SidekiqJob
    include Sidekiq::Worker

    def perform
      SidekiqCloudwatch.put_metrics
    end
  end
end
