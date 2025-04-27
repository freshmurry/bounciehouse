ActiveAdmin.register AdminUser do
  actions :all, except: [:destroy]  # You can keep "except: [:destroy]" because batch action will handle deletion

  permit_params :email, :description, :profile_image, :password, :password_confirmation, :current_password

  # Index page configuration
  index do
    selectable_column
    id_column
    column :email
    column :profile_image do |user|
      if user.profile_image.present?
        image_tag user.profile_image.url(:thumb), size: '50x50'
      else
        "No profile image"
      end
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  # Filters
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  # Form configuration
  form do |f|
    f.inputs 'Admin User Details' do
      f.input :email
      f.input :description
      f.input :profile_image, as: :file, hint: f.object.profile_image.present? ? image_tag(f.object.profile_image.url(:thumb), size: '100x100') : 'No profile image'
      f.input :current_password, as: :password, required: false, hint: 'Required to change password'
      f.input :password, required: false, hint: 'Leave blank if you do not want to change the password'
      f.input :password_confirmation, required: false, hint: 'Leave blank if you do not want to change the password'
    end
    f.actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :email
      row :description
      row :profile_image do
        if resource.profile_image.present?
          image_tag resource.profile_image.url(:medium)
        else
          "No profile image"
        end
      end
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

  # Add batch action to delete users
  batch_action :destroy, confirm: "Are you sure you want to delete the selected users?" do |ids|
    AdminUser.find(ids).each do |admin_user|
      admin_user.destroy
    end
    flash[:notice] = "Selected users have been deleted."
    redirect_to collection_path
  end
end
