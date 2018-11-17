class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def dashboard
  end

  def after_sign_in_path_for(resource)
    super
    flash[:alert] = "Signed in successfully!"  
    sign_in(resource)
    resource.role_id = 2
    case current_user.role.name
      when 'Buyer'
        if current_user.company_id != nil and current_user.company_id != ''
         new_skynet_path
        else
         # plans_path
         welcome_path
        end
      when 'Manager'
        new_skynet_path
      when 'Admin'
        dashboard_dashboard_admin_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_up_path_for_plan(resource)
     root_path
  end

  def after_sign_up_path_for(resource)
    byebug
    case current_user.role.name
      when 'Buyer'
        new_skynet_path
      when 'Manager'
        new_skynet_path
      when 'Admin'
        dashboard_dashboard_admin_path
    end
  end

  

  def self.skip_params_parsing(*paths)
    ActionDispatch::ParamsParser.skipped_paths += Array.wrap(paths).flatten
  end
end
