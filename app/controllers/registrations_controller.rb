class RegistrationsController < Devise::RegistrationsController
  protected
    def update_resource(resource, params)
      Rails.logger.debug "Updating resource with params: #{params.inspect}"
      resource.update_without_password(params)
    end
end