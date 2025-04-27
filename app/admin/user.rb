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

  show do
    attributes_table do
      row :image do
        image_tag resource.image.url(:medium) if resource.image.present?
      end
      row :fullname
      row :email
      row :phone_number
      row :address
      row :pin
      row :phone_verified
      row :last_sign_in_at
      row :created_at
      row :updated_at
    end
    active_admin_comments

    panel "Actions" do
      link_to "List a Bouncehouse", new_admin_bouncehouse_path(user_id: resource.id)
    end
  end
end
