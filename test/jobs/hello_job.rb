class HelloJob < ActiveJob::Base
  queue_as :active_job_cancel_test

  def perform
    # Do nothing
  end
end
