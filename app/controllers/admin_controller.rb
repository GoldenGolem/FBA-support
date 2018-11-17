class AdminController < ApplicationController
  layout 'application'
  # before_filter :authenticate_user!
  def index
    @users = User.all.order('created_at DESC')
  end

  def admin_login
  	
  end

 end