

class ProcessDeletevendorWorker
  include Sidekiq::Worker
  
  sidekiq_options :retry => true, :backtrace => true, :queue => :default

  def perform(vendor_id)
    puts "Processing delete vendor"
    @vendor = Vendor.find(vendor_id)
    if @vendor.present?
    	@vendor.destroy
    end
  end
end

  