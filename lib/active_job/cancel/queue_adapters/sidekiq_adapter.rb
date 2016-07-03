require 'sidekiq/api'

module ActiveJob
  module Cancel
    module QueueAdapters
      class SidekiqAdapter
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
          queue.detect { |j| j.args.first['job_id'] == job_id }
        end

        def find_from_scheduled_set(job_id, queue_name)
          scheduled_set = Sidekiq::ScheduledSet.new
          scheduled_set.detect { |j| j.args.first['job_id'] == job_id && j.args.first['queue_name'] == queue_name }
        end
      end
    end
  end
end
