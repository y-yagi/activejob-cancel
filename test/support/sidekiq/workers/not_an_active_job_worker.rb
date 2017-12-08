class NotAnActiveJobWorker
  include Sidekiq::Worker

  def perform
    # Do nothing
  end

end
