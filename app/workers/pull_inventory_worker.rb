class PullInventoryWorker
  include Sidekiq::Worker

  sidekiq_options :retry => true, :backtrace => true, :queue => :default
  def perform(file_url, user_id)
    # Do something
  end
end
