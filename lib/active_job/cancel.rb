require 'active_support'
require 'active_job'
require 'active_job/cancel/queue_adapters'
require 'active_job/cancel/version'

module ActiveJob
  module Cancel
    extend ActiveSupport::Concern

    SUPPORTED_ADAPTERS = %w(Sidekiq).freeze

    def cancel
      if self.class.supported_adapter?
        self.class.adapter_class.new.cancel(job_id, queue_name)
      else
        raise NotImplementedError, 'This queueing backend does not support cancel.'
      end
    end

    module ClassMethods
      def cancel(job_id)
        if supported_adapter?
          adapter_class.new.cancel(job_id, self.queue_name)
        else
          raise NotImplementedError, 'This queueing backend does not support cancel.'
        end
      end

      def supported_adapter?
        SUPPORTED_ADAPTERS.include?(adapter)
      end

      def adapter
        if ActiveJob.version > Gem::Version.new('4.3')
          self.queue_adapter.class.name.demodulize.chomp('Adapter')
        else
          self.queue_adapter.name.demodulize.chomp('Adapter')
        end
      end

      def adapter_class
        Object.const_get("ActiveJob::Cancel::QueueAdapters::#{adapter}Adapter")
      end
    end
  end
end

ActiveJob::Base.include(ActiveJob::Cancel)
