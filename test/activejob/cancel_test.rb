require 'test_helper'

class ActiveJob::CancelTest < Minitest::Test
  def test_unsupported_adapter
    ActiveJob::Base.queue_adapter = :inline

    assert_raises(NotImplementedError) do
      HelloJob.cancel(1)
    end
  end
end
