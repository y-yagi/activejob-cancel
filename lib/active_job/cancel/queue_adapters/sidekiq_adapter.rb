require 'sidekiq/api'

module ActiveJob
  module Cancel
    module QueueAdapters
      class SidekiqAdapter
        class << self
          def cancel(job_id, queue_name)
            result = false
            queue = Sidekiq::Queue.new(queue_name)
            job = queue.find_job(job_id)

            if job
              job.delete
              result = true
            end
            result
          end
        end
      end
    end
  end
end
