require_dependency Rails.root.join('app', 'models', 'user').to_s

ActiveAdmin.register User do
  # Enable batch actions
  config.batch_actions = true

  # Define a custom batch action for deleting users
  batch_action :destroy, confirm: "Are you sure you want to delete these users?" do |selection|
    User.where(id: selection).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{selection.count} users."
  end

  # Permit additional parameters
  permit_params do
    permitted = [:fullname, :email, :image, :enable_email, :phone_number, :address, :pin, :phone_verified]
    permitted << :password if params[:user]&.[](:password).present?
    permitted
  end
  
  controller do
    def create
      # Allow for creation without email and password
      @user = User.new(permitted_params[:user])

      if @user.save
        redirect_to admin_user_path(@user), notice: "User created successfully."
      else
        render :new
      end
    end
  end
  
  # Conditionally permit the password field
  permit_params do
    permitted = [:fullname, :email, :image, :enable_email]
    # Always include the password if it is present in the params
    if params[:user] && params[:user][:password].present?
      permitted << :password
    end
    permitted
  end
  
  # Batch action to delete users
  batch_action :destroy, confirm: "Are you sure you want to delete these users?" do |selection|
    User.where(id: selection).destroy_all
    redirect_to collection_path, notice: "#{bot_users.count} bot users deleted."
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
    column :last_sign_in_at # Display last sign-in time
    column :created_at
    actions
  end

  filter :image
  filter :fullname
  filter :email
  filter :phone_number
  filter :address
  filter :phone_verified
  filter :last_sign_in_at # Add filter for last sign-in time
  filter :created_at

  form do |f|
    f.inputs do
      f.input :fullname
      f.input :email, hint: "Optional - Leave blank if you don't want to provide an email"
      f.input :password, input_html: { autocomplete: "password" }, hint: "Leave blank if you don't want to change it"
      f.input :phone_number
      f.input :address
      f.input :pin
      f.input :phone_verified
      f.input :image, as: :file, hint: image_tag(f.object.image.url(:thumb))
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
      link_to "List a Bouncehouse", new_admin_bouncehouse_path(user_id: user.id)
    end
  end
end
