ActiveAdmin.register User do
  permit_params do
    permitted = [:fullname, :email, :password, :phone_number, :address, :enable_email, :pin, :phone_verified, :image]
    permitted
  end

  filter :image
  filter :fullname
  filter :email
  filter :phone_number
  filter :address
  filter :phone_verified
  filter :last_sign_in_at
  filter :created_at

  batch_action :destroy, confirm: "Are you sure you want to delete the selected users?" do |ids|
    batch_action_collection.where(id: ids).destroy_all
    flash[:notice] = "Selected users have been deleted."
    redirect_to collection_path
  end

  index do
    selectable_column
    id_column
    column :image do |user|
      image_tag user.image.url(:thumb) if user.image.present?
    end
    column :fullname
    column :email
    column :phone_number
    column :address
    column :pin
    column :phone_verified
    column :last_sign_in_at
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :fullname
      f.input :email, hint: "Optional - Leave blank if you don't want to provide an email"
      f.input :password, input_html: { autocomplete: "new-password" }, hint: "Leave blank if you don't want to change it"
      f.input :phone_number
      f.input :address
      f.input :pin
      f.input :phone_verified
      f.input :image, as: :file, hint: (f.object.image.present? ? image_tag(f.object.image.url(:thumb)) : "No image uploaded")
    end
    f.actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :email
      row :fullname
      row :phone_number
      row :address
      row :pin
      row :phone_verified
      row :image do
        if resource.image.present?
          image_tag resource.image.url(:medium)
        else
          "No profile image"
        end
      end
    end

    panel "Actions" do
      para link_to("List a Bouncehouse", new_admin_bouncehouse_path(user_id: resource.id))
    end

    active_admin_comments
  end

  # Controller customization
  controller do
    def update
      # If no password is being updated, skip password validation
      if password_update_required?
        unless resource.valid_password?(params[:admin_user][:current_password])
          flash[:error] = "Current password is incorrect."
          redirect_back fallback_location: edit_admin_admin_user_path(resource) and return
        end
      end

      # Update the resource with the permitted parameters
      if resource.update(admin_user_params)
        flash[:notice] = "Admin user updated successfully."
        redirect_to admin_admin_user_path(resource)
      else
        render :edit
      end
    end

    private

    # Check if password update is being requested
    def password_update_required?
      params[:admin_user][:password].present? || params[:admin_user][:password_confirmation].present?
    end

    def admin_user_params
      params.require(:admin_user).permit(:email, :description, :profile_image, :password, :password_confirmation, :current_password)
    end
  end
end
