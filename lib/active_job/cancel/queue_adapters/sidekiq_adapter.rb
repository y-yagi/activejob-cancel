require 'sidekiq/api'

module ActiveJob
  module Cancel
    module QueueAdapters
      class SidekiqAdapter
        def self.cancel(job_id, queue_name)
          queue = Sidekiq::Queue.new(queue_name)
          queue.each { |job| job.delete if job.jid == job_id }
        end
      end
    end
  end
end
