require 'test_helper'
require 'sidekiq/api'

module ActiveJob::Cancel::QueueAdapters
  class ActiveJob::Cancel::QueueAdapters::SidekiqAdapterTest< Minitest::Test
    def setup
      ActiveJob::Base.queue_adapter = :sidekiq
    end

    def teardown
    end

    def test_queued_job
      queue = Sidekiq::Queue.new('active_job_cancel_test')
      assert_equal 0, queue.size

      HelloJob.perform_later
      assert_equal 1, queue.size

      HelloJob.cancel(queue.first['jid'])
      assert_equal 0, queue.size
    ensure
      queue.clear
    end

    def test_scheduled_job
      assert_equal 0, scheduled_jobs.size

      HelloJob.set(wait: 30.seconds).perform_later
      assert_equal 1, scheduled_jobs.size

      HelloJob.cancel(scheduled_jobs.first['jid'])
      assert_equal 0, scheduled_jobs.size
    ensure
      scheduled_jobs.map(&:delete)
    end

    def scheduled_jobs
      scheduled_set = Sidekiq::ScheduledSet.new
      scheduled_set.select do |scheduled_job|
        scheduled_job.args.first['queue_name'] == 'active_job_cancel_test'
      end
    end
  end
end
