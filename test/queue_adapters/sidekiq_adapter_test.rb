require 'test_helper'
require 'sidekiq/api'

module ActiveJob::Cancel::QueueAdapters
  class ActiveJob::Cancel::QueueAdapters::SidekiqAdapterTest< Minitest::Test
    def setup
      ActiveJob::Base.queue_adapter = :sidekiq
      @queue = Sidekiq::Queue.new('active_job_cancel_test')
    end

    def teardown
      @queue.clear
    end

    def test_sidekiq_adapter
      assert_equal 0, @queue.size

      HelloJob.perform_later
      assert_equal 1, @queue.size

      HelloJob.cancel(@queue.first['jid'])
      assert_equal 0, @queue.size
    end
  end
end
