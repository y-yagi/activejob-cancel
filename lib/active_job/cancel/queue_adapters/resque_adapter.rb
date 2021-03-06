require 'resque'

module ActiveJob
  module Cancel
    module QueueAdapters
      class ResqueAdapter
        def cancel(job_id, queue_name)
          queue_name = queue_name.call if queue_name.is_a?(Proc)
          job = find_job(job_id, queue_name)

          if job
            Resque.redis.lrem(redis_key_for_queue(queue_name), 0, Resque.encode(job))
            return true
          else
            if defined?(Resque.remove_delayed_selection)
              removed_count = Resque.remove_delayed_selection { |target| target[0]["job_id"] == job_id }
              return true if removed_count > 0
            end
          end

          false
        end

        private
          def find_job(job_id, queue_name)
            jobs = Resque.list_range(redis_key_for_queue(queue_name), 0, Resque.size(queue_name))
            jobs = [jobs] if jobs.is_a?(Hash)

            jobs.find do |job|
              job["args"][0]["job_id"] == job_id
            end
          end

          def redis_key_for_queue(queue)
            "queue:#{queue}"
          end
      end
    end
  end
end
