module ActiveJob
  module QueueAdapters
    class TestAdapter
      def job_to_hash(job, extras = {})
        {
          job_id: job.job_id,
          job: job.class,
          job_class: job.class.to_s,
          args: job.serialize.fetch('arguments'),
          queue: job.queue_name
        }.merge!(extras)
      end
    end
  end
end
