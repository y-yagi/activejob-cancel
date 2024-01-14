require 'sidekiq/launcher'
require 'sidekiq/cli'
require_relative 'workers/not_an_active_job_worker'

Sidekiq.configure_server do |config|
  config.logger = Logger.new(nil)
end

def execute_with_launcher
  sidekiq = Sidekiq::Launcher.new({queues: [FailJob.queue_name.call],
                                   environment: "test",
                                   concurrency: 1,
                                   timeout: 1,
                                  })
  Sidekiq.average_scheduled_poll_interval = 3
  Sidekiq.options[:poll_interval_average] = 1
  sidekiq.run
  yield
  sidekiq.stop
end
