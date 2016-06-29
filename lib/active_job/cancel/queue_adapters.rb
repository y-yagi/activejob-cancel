module ActiveJob
  module Cancel
    module QueueAdapters
      extend ActiveSupport::Autoload

      autoload :SidekiqAdapter
    end
  end
end
