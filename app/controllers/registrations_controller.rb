class RegistrationsController < Devise::RegistrationsController
  def update_resource(resource, params)
    begin
      resource.update_attributes(params)
    rescue Aws::S3::Errors::AccessControlListNotSupported => e
      Rails.logger.error "S3 ACL error: #{e.message}"
      # Handle the error or notify the user
    end
  end
  
  protected
    def update_resource(resource, params)
      resource.update_without_password(params)
    end
end