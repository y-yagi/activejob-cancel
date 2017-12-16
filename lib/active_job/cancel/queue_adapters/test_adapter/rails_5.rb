module ActiveJob
  module QueueAdapters
    class TestAdapter
      def job_to_hash(job, extras = {})
        {
          id: job.job_id,
          job: job.class,
          args: job.serialize.fetch('arguments'),
          queue: job.queue_name
        }.merge!(extras)
      end
    end
  end
end
