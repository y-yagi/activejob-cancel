require 'test_helper'

module ActiveJob::Cancel::QueueAdapters
  class ActiveJob::Cancel::QueueAdapters::TestAdapterTest< Minitest::Test
    def setup
      ActiveJob::Base.queue_adapter = :test
      @hello_job_queue_name = HelloJob.queue_name.call
      @fail_job_queue_name = FailJob.queue_name.call
    end

    def teardown
    end

    def test_cancel_queued_job_with_instance_method
      assert_equal 0, queue.size

      job = HelloJob.perform_later
      assert_equal 1, queue.size

      job.cancel
      assert_equal 0, queue.size
    ensure
      queue.clear
    end

    def test_cancel_queued_job_with_class_method
      assert_equal 0, queue.size

      job = HelloJob.perform_later
      assert_equal 1, queue.size

      HelloJob.cancel(job.job_id)
      assert_equal 0, queue.size
    ensure
      queue.clear
    end

    def test_cancel_scheduled_job_with_instance_method
      assert_equal 0, queue.size

      job = HelloJob.set(wait: 30.seconds).perform_later
      assert_equal 1, queue.size

      job.cancel
      assert_equal 0, queue.size
    ensure
      queue.clear
    end

    def test_cancel_scheduled_job_with_class_method
      assert_equal 0, queue.size

      job = HelloJob.set(wait: 30.seconds).perform_later
      assert_equal 1, queue.size

      HelloJob.cancel(job.job_id)
      assert_equal 0, queue.size
    ensure
      queue.map(&:delete)
    end

    def test_cancel_with_invalid_id
      job = HelloJob.perform_later

      HelloJob.cancel(job.job_id.to_i + 1)
      assert_equal 1, queue.size
    ensure
      queue.clear
    end

    def test_cancel_by_with_invalid_parameters
      assert_raises(ArgumentError) { HelloJob.cancel_by(id: 1) }
    end

    def test_cancel_queued_job_with_provider_job_id
      assert_equal 0, queue.size

      HelloJob.perform_later
      assert_equal 1, queue.size

      HelloJob.cancel_by(provider_job_id: queue.map.first[:id])
      assert_equal 0, queue.size
    ensure
      queue.clear
    end

    def test_cancel_scheduled_job_with_provider_job_id
      assert_equal 0, queue.size

      HelloJob.set(wait: 30.seconds).perform_later
      assert_equal 1, queue.size

      HelloJob.cancel_by(provider_job_id: queue.map.first[:id])
      assert_equal 0, queue.size
    ensure
      queue.map(&:delete)
    end

    def test_cancel_by_with_invalid_job_id
      HelloJob.perform_later

      refute HelloJob.cancel_by(provider_job_id: queue.map.first[:id].to_i + 1)
      assert_equal 1, queue.size
    ensure
      queue.clear
    end

    private
      def queue
        ActiveJob::Base.queue_adapter.enqueued_jobs
      end
  end
end
