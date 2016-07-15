module ActiveJob
  module Cancel
    module QueueAdapters
      extend ActiveSupport::Autoload

      autoload :SidekiqAdapter
      autoload :DelayedJobAdapter
    end
  end
end
