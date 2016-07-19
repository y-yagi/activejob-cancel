class FailJob < ActiveJob::Base
  queue_as :active_job_cancel_failed_job

  def perform
    raise 'something wrong'
  end
end
