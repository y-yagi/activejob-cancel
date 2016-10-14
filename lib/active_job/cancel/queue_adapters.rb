module ActiveJob
  module Cancel
    module QueueAdapters
      extend ActiveSupport::Autoload

      autoload :SidekiqAdapter
      autoload :DelayedJobAdapter
      autoload :ResqueAdapter
    end
  end
end
