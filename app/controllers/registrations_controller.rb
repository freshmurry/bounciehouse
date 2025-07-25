class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Allow users to update their profile without password unless they are changing it
  def update_resource(resource, params)
    resource.image = params[:image] if params[:image].present?
    if params[:password].present?
      resource.update_with_password(params)
    else
      resource.update_without_password(params.except(:image_file_name, :image_file_size, :image_content_type, :image_updated_at))
    end
  rescue Aws::S3::Errors::AccessControlListNotSupported => e
    Rails.logger.error "S3 ACL error: #{e.message}"
  end

  # Permit additional parameters for sign up and account update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname, :image, :phone_number, :address, :description])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname, :image, :phone_number, :address, :description])
  end
end
