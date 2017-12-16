module ActiveJob
  module Cancel
    module QueueAdapters
      extend ActiveSupport::Autoload

      autoload :SidekiqAdapter
      autoload :DelayedJobAdapter
      autoload :ResqueAdapter
      autoload :TestAdapter
    end
  end
end
