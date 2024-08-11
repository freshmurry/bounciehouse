# app/admin/users.rb
ActiveAdmin.register User do
  # Conditionally permit the password field
  permit_params do
    permitted = [:fullname, :email, :image, :enable_email]
    permitted << :password if params[:user][:password].present?
    permitted
  end

  index do
    selectable_column
    id_column
    column :image do |user|
      image_tag user.image.url(:thumb) if user.image.present?
    end
    column :fullname
    column :email
    # column :description
    # column :enable_email
    column :created_at
    actions
  end

  filter :image
  filter :fullname
  filter :email
  # filter :description
  filter :created_at

  form do |f|
    f.inputs do
      f.input :fullname
      f.input :email
      f.input :password, input_html: { autocomplete: "new-password" }, hint: "Leave blank if you don't want to change it"
      f.input :image, as: :file, hint: image_tag(f.object.image.url(:thumb))
      # f.input :description
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
      # row :description
      row :created_at
      row :updated_at
    end
    active_admin_comments
    
    panel "Actions" do
      link_to "List a Bouncehouse", new_admin_bouncehouse_path(user_id: user.id)
    end
  end
end
