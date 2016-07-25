require 'test_helper'
require 'active_record'
require 'support/delayed_job/test_helper'
require 'delayed_job'
require 'delayed_job_active_record'

module ActiveJob::Cancel::QueueAdapters
  class ActiveJob::Cancel::QueueAdapters::DelayedJobAdapterTest< Minitest::Test
    def setup
      ActiveJob::Base.queue_adapter = :delayed_job
      setup_db
    end

    def teardown
    end

    def test_cancel_with_instance_method
      assert_equal 0, Delayed::Job.count

      job = HelloJob.perform_later
      assert_equal 1, Delayed::Job.count

      job.cancel
      assert_equal 0, Delayed::Job.count
    ensure
      Delayed::Job.destroy_all
    end

    def test_cancel_with_class_method
      assert_equal 0, Delayed::Job.count

      job = HelloJob.perform_later
      assert_equal 1, Delayed::Job.count

      HelloJob.cancel(job.job_id)
      assert_equal 0, Delayed::Job.count
    ensure
      Delayed::Job.destroy_all
    end

    def test_cancel_with_invalid_id
      job = HelloJob.perform_later
      refute HelloJob.cancel(job.job_id.to_i + 1)
      assert_equal 1, Delayed::Job.count
    ensure
      Delayed::Job.destroy_all
    end

    def test_cancel_with_provider_job_id
      assert_equal 0, Delayed::Job.count

      HelloJob.perform_later
      assert_equal 1, Delayed::Job.count

      HelloJob.cancel_by(provider_job_id: Delayed::Job.first.id)
      assert_equal 0, Delayed::Job.count
    ensure
      Delayed::Job.destroy_all
    end

    def test_cancel_by_with_invalid_parameters
      assert_raises(ArgumentError) { HelloJob.cancel_by(id: 1) }
    end

    def test_cancel_by_with_invalid_job_id
      HelloJob.perform_later
      refute HelloJob.cancel_by(provider_job_id: Delayed::Job.first.id + 1)
      assert_equal 1, Delayed::Job.count
    ensure
      Delayed::Job.destroy_all
    end
  end
end
