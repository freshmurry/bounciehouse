ActiveAdmin.register AdminUser do
  # Permit parameters
  permit_params :fullname, :email, :phone, :description, :password, :password_confirmation

  # Index page configuration
  index do
    selectable_column
    id_column
    column :email
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
    f.inputs do
      f.input :email
      f.input :phone
      f.input :description
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  # Show page configuration
  show do |user|
    attributes_table do
      row :fullname
      row :email
      row :phone
      row :description
      row :profile_image do
        image_tag url_for(user.profile_image) if user.profile_image.attached?
      end
    end
    active_admin_comments
  end
end
