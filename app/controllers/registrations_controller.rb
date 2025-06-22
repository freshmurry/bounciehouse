<<<<<<< HEAD
# class RegistrationsController < Devise::RegistrationsController
#   def update_resource(resource, params)
#     begin
#       resource.update_attributes(params)
#     rescue Aws::S3::Errors::AccessControlListNotSupported => e
#       Rails.logger.error "S3 ACL error: #{e.message}"
#       # Handle the error or notify the user
#     end
#   end
  
#   protected
#     def update_resource(resource, params)
#       resource.update_without_password(params)
#     end
# end
class RegistrationsController < Devise::RegistrationsController
  # Override the update_resource method to update the resource without requiring the password
  protected

  def update_resource(resource, params)
    # Try to update resource without requiring the password
=======
class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Allow users to update their profile without password unless they are changing it
  def update_resource(resource, params)
    resource.image = params[:image] if params[:image].present?
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
    if params[:password].present?
      resource.update_with_password(params)
    else
      resource.update_without_password(params)
    end
  rescue Aws::S3::Errors::AccessControlListNotSupported => e
    Rails.logger.error "S3 ACL error: #{e.message}"
<<<<<<< HEAD
    # Handle the error or notify the user
  end
end
=======
  end

  # Permit additional parameters for sign up and account update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname, :image, :phone_number, :address, :description])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname, :image, :phone_number, :address, :description])
  end
end
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
