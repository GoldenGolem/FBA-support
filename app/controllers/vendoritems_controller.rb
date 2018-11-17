class VendoritemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @vendor_id = params[:vendor]
    @clean_vendor = params[:delete_vendor]
    if (@clean_vendor)
      vendoritems = current_user.vendoritems.where(:vendor_id => @clean_vendor)
      if vendoritems.empty? || vendoritems.blank?
        flash[:error] = "There is no items to delete."
        redirect_to vendoritems_path
      else
        if vendoritems.count < 100
          vendoritems.destroy_all
        else
          ProcessDeletevendoritemWorker.perform_async(@clean_vendor);
        end
        flash[:success] = "Deleted all items successfully."
        redirect_to vendors_path(:user => current_user.id)
      end
    end

    if @vendor_id.nil? || @vendor_id.empty?
      if current_user.get_vendors.present?
        @vendor_id = current_user.get_vendors.first.id
      else
        redirect_to vendors_path(:user => current_user), :flash => { :notice => "Please create Vednor first." }
      end
      
    end
  end


  def show
    
  end

  def updatevendoritem

    @vendoritem = nil
    data = params[:data]
    data.each do |key, item|
      @vendoritem = Vendoritem.find(key)

      item.each do |title, value|
        if title=='buyboxprice'
          @vendoritem.vendorasin[title.to_sym] = value
        else
          @vendoritem[title.to_sym] = value  
        end
        
      end
      @vendoritem.save
    end
    
    render json: {'data'=>@vendoritem}
  end

end
