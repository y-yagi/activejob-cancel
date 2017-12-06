require 'sidekiq/api'

module ActiveJob
  module Cancel
    module QueueAdapters
      class SidekiqAdapter
        def cancel(job_id, queue_name)
          queue_name = queue_name.call if queue_name.is_a?(Proc)
          job = find_job_by_job_id(job_id, queue_name)

          if job
            job.delete
            return true
          end

          false
        end

        def cancel_by(opts, queue_name)
          raise ArgumentError, 'Please specify ":provider_job_id"' unless opts[:provider_job_id]

          queue_name = queue_name.call if queue_name.is_a?(Proc)
          job = find_job_by_provider_job_id(opts[:provider_job_id], queue_name)
          if job
            job.delete
            return true
          end

          false
        end

        private
          def find_job_by_job_id(job_id, queue_name)
            find_job_from_queue(job_id, queue_name) || find_job_from_scheduled_set(job_id) || find_job_from_retry_set(job_id)
          end

          def find_job_by_provider_job_id(provider_job_id, queue_name)
            Sidekiq::Queue.new(queue_name).find_job(provider_job_id) ||
            Sidekiq::ScheduledSet.new.find_job(provider_job_id) ||
            Sidekiq::RetrySet.new.find_job(provider_job_id)
          end

          def find_job_from_queue(job_id, queue_name)
            queue = Sidekiq::Queue.new(queue_name)
            queue.detect { |j| j.args.first.is_a?(Hash) && j.args.first['job_id'] == job_id }
          end

          def find_job_from_scheduled_set(job_id)
            scheduled_set = Sidekiq::ScheduledSet.new
            scheduled_set.detect { |j| j.args.first.is_a?(Hash) && j.args.first['job_id'] == job_id }
          end

          def find_job_from_retry_set(job_id)
            scheduled_set = Sidekiq::RetrySet.new
            scheduled_set.detect { |j| j.args.first.is_a?(Hash) && j.args.first['job_id'] == job_id }
          end
      end
    end
  end
end
