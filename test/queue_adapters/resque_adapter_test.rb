require 'test_helper'
require 'resque'

module ActiveJob::Cancel::QueueAdapters
  class ActiveJob::Cancel::QueueAdapters::ResqueAdapterTest< Minitest::Test
    def setup
      ActiveJob::Base.queue_adapter = :resque
      @hello_job_queue_name = HelloJob.queue_name.call
    end

    def test_cancel_queued_job_with_instance_method
      assert_equal 0, Resque.size(@hello_job_queue_name)

      job = HelloJob.perform_later
      assert_equal 1, Resque.size(@hello_job_queue_name)

      job.cancel
      assert_equal 0, Resque.size(@hello_job_queue_name)
    ensure
      Resque.remove_queue(@hello_job_queue_name)
    end

    def test_cancel_with_class_method
      assert_equal 0, Resque.size(@hello_job_queue_name)

      job = HelloJob.perform_later
      assert_equal 1, Resque.size(@hello_job_queue_name)

      HelloJob.cancel(job.job_id)
      assert_equal 0, Resque.size(@hello_job_queue_name)
    ensure
      Resque.remove_queue(@hello_job_queue_name)
    end

    def test_cancel_scheduled_job
      assert_equal 0, delayed_jobs.size

      job = HelloJob.set(wait: 1.hour).perform_later
      assert_equal 1, delayed_jobs.size

      job.cancel
      assert_equal 0, delayed_jobs.size
    ensure
      Resque.remove_delayed_selection { true }
    end

    def test_cancel_with_invalid_id
      job = HelloJob.perform_later
      refute HelloJob.cancel(job.job_id.to_i + 1)
      assert_equal 1, Resque.size(@hello_job_queue_name)
    ensure
      Resque.remove_queue(@hello_job_queue_name)
    end

    private
      def delayed_jobs
        Resque.find_delayed_selection do |job|
          job[0]["job_class"] == "HelloJob" && job[0]["queue_name"] == @hello_job_queue_name
        end
      end
  end
end
