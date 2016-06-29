require 'active_support'
require 'active_job/core'
require 'active_job/cancel/queue_adapters'
require 'active_job/cancel/version'

module ActiveJob
  module Cancel
    extend ActiveSupport::Concern

    SUPPORTED_ADAPTERS = %w(Sidekiq).freeze

    module ClassMethods
      def cancel(job_id)
        if supported_adapter?
          adapter_class.cancel(job_id, self.queue_name)
        else
          raise NotImplementedError, 'This queueing backend does not support cancel.'
        end
      end

      private
        def supported_adapter?
          SUPPORTED_ADAPTERS.include?(adapter)
        end

        def adapter
          self.queue_adapter.name.demodulize.chomp('Adapter')
        end

        def adapter_class
          Object.const_get("ActiveJob::Cancel::QueueAdapters::#{adapter}Adapter")
        end
    end
  end
end

ActiveJob::Core.include(ActiveJob::Cancel)
