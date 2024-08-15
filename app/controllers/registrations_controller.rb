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
    if params[:password].present?
      resource.update_with_password(params)
    else
      resource.update_without_password(params)
    end
  rescue Aws::S3::Errors::AccessControlListNotSupported => e
    Rails.logger.error "S3 ACL error: #{e.message}"
    # Handle the error or notify the user
  end
end
