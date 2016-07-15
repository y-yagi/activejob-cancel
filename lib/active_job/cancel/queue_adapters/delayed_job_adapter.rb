require 'delayed_job'
require 'delayed_job_active_record'

module ActiveJob
  module Cancel
    module QueueAdapters
      class DelayedJobAdapter
        def cancel(job_id, queue_name)
          job = find_job(job_id, queue_name)
          if job
            job.destroy
            return true
          end
          false
        end

        def cancel_by(opts, queue_name)
          raise ArgumentError, 'Please specify ":provider_job_id"' unless opts[:provider_job_id]
          job_id = opts[:provider_job_id]

          job = Delayed::Job.find_by(id: job_id)
          if job
            job.destroy
            return true
          end
          false
        end

        private
          def find_job(job_id, queue_name)
            Delayed::Job.where('handler LIKE ?', "%job_id: #{job_id}%").where(queue: queue_name).first
          end
      end
    end
  end
end
