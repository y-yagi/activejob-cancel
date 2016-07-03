require 'test_helper'

class ActiveJob::CancelTest < Minitest::Test
  def test_unsupported_adapter
    ActiveJob::Base.queue_adapter = :inline

    assert_raises(NotImplementedError) do
      HelloJob.cancel(1)
    end
  end

  def test_sidekiq_adapter_work_cancel
    ActiveJob::Base.queue_adapter = :sidekiq
    refute HelloJob.cancel(1)
  end

  def test_sidekiq_adapter_work_cancel_by
    ActiveJob::Base.queue_adapter = :sidekiq
    refute HelloJob.cancel_by(provider_job_id: 1)
  end
end
