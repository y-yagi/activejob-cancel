require 'test_helper'

class ActiveJob::CancelTest < Minitest::Test

  if ActiveJob.version > Gem::Version.new('4.3')
    def test_instance_method_wit_unsupported_adapter
      before_adapter = ActiveJob::Base.queue_adapter
      ActiveJob::Base.queue_adapter = :async
      job = HelloJob.set(wait: 30.seconds).perform_later

      assert_raises(NotImplementedError) do
        job.cancel(1)
      end
    ensure
      ActiveJob::Base.queue_adapter = before_adapter
    end
  end

  def test_class_method_with_unsupported_adapter
    before_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :inline

    assert_raises(NotImplementedError) do
      HelloJob.cancel(1)
    end
  ensure
    ActiveJob::Base.queue_adapter = before_adapter
  end

  def test_cancel_by_with_unsupported_adapter
    before_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :inline

    assert_raises(NotImplementedError) do
      HelloJob.cancel_by(provider_job_id: 1)
    end
  ensure
    ActiveJob::Base.queue_adapter = before_adapter
  end
end
