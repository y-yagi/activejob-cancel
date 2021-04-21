module ActiveJob
  module QueueAdapters
    class TestAdapter
      alias original_job_to_hash job_to_hash

      def job_to_hash(job, extras = {})
        original_job_to_hash(job, extras).merge!({
          id: job.job_id,
          job: job.class,
          args: job.serialize.fetch('arguments'),
          queue: job.queue_name
        })
      end
    end
  end
end
