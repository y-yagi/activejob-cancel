module ActiveJob
  module QueueAdapters
    class TestAdapter
      alias original_enqueue enqueue
      alias original_enqueue_at enqueue_at

      def fixup_last_job(job)
        list = perform_enqueued_jobs ? performed_jobs : enqueued_jobs
        list.last[:id] = job.job_id
      end

      def enqueue(job)
        result = original_enqueue(job)
        fixup_last_job(job)
        result
      end

      def enqueue_at(job, timestamp)
        result = original_enqueue_at(job, timestamp)
        fixup_last_job(job)
        result
      end
    end
  end
end
