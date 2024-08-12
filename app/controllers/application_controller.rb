class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  # Define the path to redirect after sign-in based on user type
  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      authenticated_admin_root_path  # Redirect admin users to the admin dashboard
    else
      root_path  # Redirect regular users to the main app's root path
    end
  end

  # Handle ActiveRecord::RecordNotFound exception
  def record_not_found
    redirect_to bouncehouses_url, alert: 'Record not found.'
  end

  # Permit additional parameters for Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname, :phone_number, :description, :image])
  end

  before_action :authenticate_admin_user!, if: :admin_controller?

  private

  # Determine if the current request is for an admin controller
  def admin_controller?
    controller_path.start_with?('admin/')
  end
end
