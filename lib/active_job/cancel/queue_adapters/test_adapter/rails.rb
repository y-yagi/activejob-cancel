module ActiveJob
  module QueueAdapters
    class TestAdapter

      def job_to_hash(job, extras = {})
        # These values should match up with what other ActiveJob::QueueAdapters publish. At minimum, job_class, job_id, arguments...
        # Otherwise, ActiveJob test helpers like assert_enqueued_with will break.
        HashWithIndifferentAccess.new({
          id: job.job_id,
          job_id: job.job_id,
          job: job.class,
          job_class: job.class.to_s,
          args: job.serialize.fetch('arguments'),
          arguments: job.serialize.fetch('arguments'),
          queue: job.queue_name,
          queue_name: job.queue_name
        }.merge!(extras))
      end
    end
  end
end
