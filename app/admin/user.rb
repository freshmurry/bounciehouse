# app/admin/users.rb
ActiveAdmin.register User do
  permit_params :fullname, :email, :password, :image, :enable_sms, :enable_email

  index do
    selectable_column
    id_column
    column :image
    column :fullname
    column :email
    column :password
    column :enable_sms
    column :enable_email
    column :created_at
    actions
  end
  
  filter :image
  filter :fullname
  filter :email
  filter :password
  filter :enable_sms
  filter :enable_email
  filter :created_at

  form do |f|
    f.inputs do
      f.input :fullname
      f.input :email
      f.input :password
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :image do
        image_tag user.image.url(:medium) if user.image.present?
      end
      row :fullname
      row :email
      row :image
      row :user_id
      row :enable_sms
      row :enable_email
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
