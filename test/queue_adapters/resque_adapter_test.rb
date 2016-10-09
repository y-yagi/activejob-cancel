require 'test_helper'
require 'resque'

module ActiveJob::Cancel::QueueAdapters
  class ActiveJob::Cancel::QueueAdapters::ResqueAdapterTest< Minitest::Test
    def setup
      ActiveJob::Base.queue_adapter = :resque
    end

    def test_cancel_queued_job_with_instance_method
      assert_equal 0, Resque.size(HelloJob.queue_name)

      job = HelloJob.perform_later
      assert_equal 1, Resque.size(HelloJob.queue_name)

      job.cancel
      assert_equal 0, Resque.size(HelloJob.queue_name)
    ensure
      Resque.remove_queue(HelloJob.queue_name)
    end

    def test_cancel_with_class_method
      assert_equal 0, Resque.size(HelloJob.queue_name)

      job = HelloJob.perform_later
      assert_equal 1, Resque.size(HelloJob.queue_name)

      HelloJob.cancel(job.job_id)
      assert_equal 0, Resque.size(HelloJob.queue_name)
    ensure
      Resque.remove_queue(HelloJob.queue_name)
    end

    def test_cancel_with_invalid_id
      job = HelloJob.perform_later
      refute HelloJob.cancel(job.job_id.to_i + 1)
      assert_equal 1, Resque.size(HelloJob.queue_name)
    ensure
      Resque.remove_queue(HelloJob.queue_name)
    end
  end
end
