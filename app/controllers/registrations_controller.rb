class RegistrationsController < Devise::RegistrationsController
#   protected
#     def update_resource(resource, params)
#       resource.update_without_password(params)
#     end
# end

protected
    def update_resource(resource, params)
      if params[:image] # Replace :image with the actual attribute name if needed
        resource.update(params)
      else
        resource.update_without_password(params)
      end
    end
end