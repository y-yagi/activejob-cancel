require 'test_helper'
require 'sidekiq/api'
require 'support/sidekiq/test_helper'

module ActiveJob::Cancel::QueueAdapters
  class ActiveJob::Cancel::QueueAdapters::SidekiqAdapterTest< Minitest::Test
    def setup
      ActiveJob::Base.queue_adapter = :sidekiq
    end

    def teardown
    end

    def test_cancel_queued_job_with_instance_method
      queue = Sidekiq::Queue.new('active_job_cancel_test')
      assert_equal 0, queue.size

      job = HelloJob.perform_later
      assert_equal 1, queue.size

      job.cancel
      assert_equal 0, queue.size
    ensure
      queue.clear
    end

    def test_cancel_queued_job_with_class_method
      queue = Sidekiq::Queue.new('active_job_cancel_test')
      assert_equal 0, queue.size

      job = HelloJob.perform_later
      assert_equal 1, queue.size

      HelloJob.cancel(job.job_id)
      assert_equal 0, queue.size
    ensure
      queue.clear
    end

    def test_cancel_scheduled_job_with_instance_method
      assert_equal 0, scheduled_jobs.size

      job = HelloJob.set(wait: 30.seconds).perform_later
      assert_equal 1, scheduled_jobs.size

      job.cancel
      assert_equal 0, scheduled_jobs.size
    ensure
      scheduled_jobs.map(&:delete)
    end

    def test_cancel_scheduled_job_with_class_method
      assert_equal 0, scheduled_jobs.size

      job = HelloJob.set(wait: 30.seconds).perform_later
      assert_equal 1, scheduled_jobs.size

      HelloJob.cancel(job.job_id)
      assert_equal 0, scheduled_jobs.size
    ensure
      scheduled_jobs.map(&:delete)
    end

    def test_cancel_retries_job_with_instance_method
      retries_jobs.map(&:delete)
      assert_equal 0, retries_jobs.size

      job = nil
      execute_with_launcher do
        job = FailJob.perform_later
      end
      sleep 3  # wait for the launcher to run the job
      assert_equal 1, retries_jobs.size

      job.cancel
      assert_equal 0, retries_jobs.size
    ensure
      retries_jobs.map(&:delete)
    end

    def test_cancel_retries_job_with_class_method
      retries_jobs.map(&:delete)
      assert_equal 0, retries_jobs.size

      job = nil
      execute_with_launcher do
        job = FailJob.perform_later
      end
      sleep 3  # wait for the launcher to run the job
      assert_equal 1, retries_jobs.size

      FailJob.cancel(job.job_id)
      assert_equal 0, retries_jobs.size
    ensure
      retries_jobs.map(&:delete)
    end

    def test_cancel_by_with_invalid_parameters
      assert_raises(ArgumentError) { HelloJob.cancel_by(id: 1) }
    end

    def test_cancel_queued_job_with_provider_job_id
      queue = Sidekiq::Queue.new('active_job_cancel_test')
      assert_equal 0, queue.size

      HelloJob.perform_later
      assert_equal 1, queue.size

      queue = Sidekiq::Queue.new(HelloJob.queue_name)
      HelloJob.cancel_by(provider_job_id: queue.map.first.jid)
      assert_equal 0, queue.size
    ensure
      queue.clear
    end

    def test_cancel_scheduled_job_with_provider_job_id
      assert_equal 0, scheduled_jobs.size

      HelloJob.set(wait: 30.seconds).perform_later
      assert_equal 1, scheduled_jobs.size

      HelloJob.cancel_by(provider_job_id: scheduled_jobs.map.first.jid)
      assert_equal 0, scheduled_jobs.size
    ensure
      scheduled_jobs.map(&:delete)
    end

    private
      def scheduled_jobs
        scheduled_set = Sidekiq::ScheduledSet.new
        scheduled_set.select do |scheduled_job|
          scheduled_job.args.first['queue_name'] == 'active_job_cancel_test'
        end
      end

      def retries_jobs
        retry_set = Sidekiq::RetrySet.new
        retry_set.select do |retry_job|
          retry_job.args.first['queue_name'] == 'active_job_cancel_failed_job'
        end
      end
  end
end
