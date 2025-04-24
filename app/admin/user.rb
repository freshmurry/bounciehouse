require_dependency Rails.root.join('app', 'models', 'user').to_s

ActiveAdmin.register User do
  config.batch_actions = true
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
  
  batch_action :destroy_bots, confirm: "Are you sure you want to delete selected bot users?" do |selection|
    users = User.where(id: selection)

    # Custom logic to detect bots — adjust this to your real criteria
    bot_users = users.select { |u| u.email.blank? && u.fullname.downcase.include?("bot") }

    bot_users.each(&:destroy)

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
    column :last_sign_in_at # Display last sign-in time
    column :created_at
    actions
  end

  filter :image
  filter :fullname
  filter :email
  filter :last_sign_in_at # Add filter for last sign-in time
  filter :created_at

  form do |f|
    f.inputs do
      f.input :fullname
      f.input :email, hint: "Optional - Leave blank if you don't want to provide an email"
      f.input :password, input_html: { autocomplete: "password" }, hint: "Leave blank if you don't want to change it"
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
      row :last_sign_in_at # Display last sign-in time
      row :created_at
      row :updated_at
    end
    active_admin_comments

    panel "Actions" do
      link_to "List a Bouncehouse", new_admin_bouncehouse_path(user_id: user.id)
    end
  end
end
