ActiveAdmin.register AdminUser do
  # Permit parameters
  permit_params :name, :email, :description, :password, :password_confirmation, :profile_image

  # Index page configuration
  index do
    selectable_column
    id_column
    # column :name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  # Filters
  # filter :name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  # Form configuration
  form do |f|
    f.inputs do
      # f.input :name
      f.input :email
      f.input :profile_image, as: :file

      # Only show the password fields if the user is creating a new record
      if f.object.new_record? || f.object.password.present?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

  # Show page configuration
  show do |user|
    attributes_table do
      # row :name
      row :email
      row :profile_image do
        if user.profile_image.present?
          image_tag user.profile_image.url(:medium) # or specify another style
        else
          "No profile image"
        end
      end  
    end
    active_admin_comments
  end
end
