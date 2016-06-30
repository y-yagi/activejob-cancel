require 'sidekiq/api'

module ActiveJob
  module Cancel
    module QueueAdapters
      class SidekiqAdapter
        class << self
          def cancel(job_id, queue_name)
            job = find_from_queue(job_id, queue_name) || find_from_scheduled_set(job_id, queue_name)

            if job
              job.delete
              return true
            end
            false
          end

          def find_from_queue(job_id, queue_name)
            queue = Sidekiq::Queue.new(queue_name)
            queue.find_job(job_id)
          end

          def find_from_scheduled_set(job_id, queue_name)
            scheduled_set = Sidekiq::ScheduledSet.new
            scheduled_set.find_job(job_id)
          end
        end
      end
    end
  end
end
