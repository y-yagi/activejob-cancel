require 'sidekiq/launcher'
require 'sidekiq/cli'
require_relative 'workers/not_an_active_job_worker'

Sidekiq.configure_server do |config|
  config.logger = Logger.new(nil)
end

def execute_with_launcher
  if Gem::Version.new(Sidekiq::VERSION) >= Gem::Version.new("7")
    config = Sidekiq.default_configuration
    config.queues = [FailJob.queue_name.call]
    config.concurrency = 1
    config.average_scheduled_poll_interval = 0.5
    config.merge!(
      environment: "test",
      timeout: 1,
      poll_interval_average: 3
    )
  else
    config = {
      queues: [FailJob.queue_name.call],
      environment: "test",
      concurrency: 1,
      timeout: 1,
      average_scheduled_poll_interval: 0.5,
      poll_interval_average: 3
    }
  end

  sidekiq = Sidekiq::Launcher.new(config)
  sidekiq.run
  sleep 0.2
  yield
  sidekiq.stop
end
