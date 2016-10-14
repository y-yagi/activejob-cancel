class HelloJob < ActiveJob::Base
  queue_as { 'active_job_cancel_test_' + RUBY_VERSION + '_' + ActiveJob.version.to_s }

  def perform
    # Do nothing
  end
end
