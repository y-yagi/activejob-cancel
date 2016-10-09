require 'active_support'
require 'active_job'
require 'active_job/cancel/queue_adapters'
require 'active_job/cancel/version'

module ActiveJob
  module Cancel
    extend ActiveSupport::Concern

    SUPPORTED_ADAPTERS = %w(Sidekiq DelayedJob Resque).freeze

    def cancel
      if self.class.can_cancel?
        self.class.cancel_adapter_class.new.cancel(job_id, queue_name)
      else
        raise NotImplementedError, 'This queueing backend does not support cancel.'
      end
    end

    module ClassMethods
      def cancel(job_id)
        if can_cancel?
          cancel_adapter_class.new.cancel(job_id, self.queue_name)
        else
          raise NotImplementedError, 'This queueing backend does not support cancel.'
        end
      end

      def cancel_by(opts)
        if can_cancel?
          cancel_adapter_class.new.cancel_by(opts, self.queue_name)
        else
          raise NotImplementedError, 'This queueing backend does not support cancel_by.'
        end
      end

      def can_cancel?
        SUPPORTED_ADAPTERS.include?(adapter_name)
      end

      def cancel_adapter_class
        Object.const_get("ActiveJob::Cancel::QueueAdapters::#{adapter_name}Adapter")
      end

      private
        def adapter_name
          if ActiveJob.version > Gem::Version.new('4.3')
            self.queue_adapter.class.name.demodulize.chomp('Adapter')
          else
            self.queue_adapter.name.demodulize.chomp('Adapter')
          end
        end
    end
  end
end

ActiveSupport.on_load(:active_job) do
  include(ActiveJob::Cancel)
end
