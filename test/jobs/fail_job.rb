class FailJob < ActiveJob::Base
  queue_as { 'active_job_cancel_failed_job_' + RUBY_VERSION + '_' + ActiveJob.version.to_s }

  def perform
    raise 'something wrong'
  end
end
