require 'active_job'

module ActiveJob
  module QueueAdapters
    # Unfortunately we need to monkey patch the Rails TestAdapter class,
    # because it does not save the job id on the enqueued_jobs array. We rely
    # on a persisted id to fulfill the canceling of any given job id.
    class TestAdapter
      def initialize
        if Gem::Requirement.new('~> 5.0').satisfied_by? ActiveJob.version
          require 'active_job/cancel/queue_adapters/test_adapter/rails_5'
        elsif Gem::Requirement.new('~> 4.2').satisfied_by? ActiveJob.version
          require 'active_job/cancel/queue_adapters/test_adapter/rails_4'
        end

        super
      end
    end
  end

  module Cancel
    module QueueAdapters
      class TestAdapter
        def cancel(job_id, queue_name)
          original_count = adapter.enqueued_jobs.count
          adapter.enqueued_jobs = reject_job_from_enqueued_jobs(job_id)
          (original_count == adapter.enqueued_jobs.count) ? false : true
        end

        def cancel_by(opts, queue_name)
          unless opts[:provider_job_id]
            raise ArgumentError, 'Please specify ":provider_job_id"'
          end
          self.cancel(opts[:provider_job_id], queue_name)
        end

        private
          def adapter
            ActiveJob::Base.queue_adapter
          end

          def reject_job_from_enqueued_jobs(job_id)
            adapter.enqueued_jobs.reject { |job| job[:id] == job_id }
          end
      end
    end
  end
end
