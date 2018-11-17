

class ProcessDeletevendoritemWorker
  include Sidekiq::Worker
  
  sidekiq_options :retry => true, :backtrace => true, :queue => :default

  def perform(vendor_id)

    puts "Processing delete vendor item"
    Vendoritem.where(:vendor_id => vendor_id).destroy_all         
  end
end

  