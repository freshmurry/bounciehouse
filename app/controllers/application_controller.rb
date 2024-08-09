class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  # Define the path to redirect after sign-in
  def after_sign_in_path_for(resource_or_scope)
    dashboard_path  # Replace with your desired path
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
end
