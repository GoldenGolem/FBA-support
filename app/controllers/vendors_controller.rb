class VendorsController < ApplicationController
  before_action :authenticate_user!
  def new
    @vendor = Vendor.new
  end
  
  def create
    @vendor = Vendor.new(vendor_param)
    @vendor.user_id = current_user.id

    if Vendor.exists?(name: vendor_param[:name])
      flash[:notice] = 'Vendor name is already exist.'
      redirect_to vendors_path(:user => current_user.id)
      return
    else
      if @vendor.save
        redirect_to vendors_path(:user => current_user.id)
      else
        redirect_to :back
      end      
    end
  end

  def index
    @vendor_id = params[:vendor]
    @vendors = current_user.get_vendors
    skynets = current_user.get_skynets

    if @vendor_id.nil? || @vendor_id.empty?
      if @vendors.present?
        if skynets.present?
          @secondmessage = false
        else
          @secondmessage = true  
        end
        @vendor_id = @vendors.first.id
        @firstmessage = false
      else
        @firstmessage = true        
      end
    end

   
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  def update
    vendor = Vendor.find(params[:id])
    if vendor.update(vendor_params)
      redirect_to vendors_path(:user => current_user.id)
    else
      flash[:notice] = 'User data is not updated'
    end
  end

  def destroy
    vendor = Vendor.find(params[:id])
    if vendor.vendoritems.count > 100
      ProcessDeletevendorWorker.perform_async(params[:id]);
    else
      vendor. destroy
    end
    
    redirect_to vendors_path(:user => current_user.id)
  end

  def show
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :addressline1, :addressline2, :city, :zipcode, :state, :account_number, :contact, :title, :phone, :email, :website, :dropship, :crossdock, :login, :password, :ref_name, :ref_title, :ref_email, :ref_fax, :leadtime, :vendor_category_id)
  end

  def vendor_param
    params.require(:vendor).permit(:name, :vendor_category_id, :account_number, :contact)
  end
end
