RSpec.describe SidekiqCloudwatch do
  it "has a version number" do
    expect(SidekiqCloudwatch::VERSION).not_to be nil
  end

  describe '#put_metrics' do
    let(:stubbed_stats) do
      instance_double(
        'Sidekiq::Stats',
        scheduled_size: 5,
        retry_size: 9,
        processes_size: 10,
        default_queue_latency: 0,
        workers_size: 0,
        dead_size: 5,
        enqueued: 99
      )
    end

    let(:stubbed_cloudwatch_api) do
      instance_double('Aws::CloudWatch::Metric', put_data: nil)
    end

    before do
      allow(Sidekiq::Stats).to receive(:new).and_return(stubbed_stats)
      allow(Aws::CloudWatch::Metric).to receive(:new).and_return(stubbed_cloudwatch_api)
      SidekiqCloudwatch.put_metrics
    end

    it 'will get stats from Sidekiq' do
      expect(stubbed_stats).to have_received(:scheduled_size)
    end

    it 'will send metrics to cloudwatch' do
      expect(stubbed_cloudwatch_api).to have_received(:put_data)
    end
  end
end
