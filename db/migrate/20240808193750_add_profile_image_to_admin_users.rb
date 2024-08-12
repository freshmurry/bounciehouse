class AddProfileImageToAdminUsers < ActiveRecord::Migration[5.0]
  def change
    add_attachment :admin_users, :profile_image

    # Only add columns if they do not already exist
    unless column_exists?(:admin_users, :profile_image_file_name)
      add_column :admin_users, :profile_image_file_name, :string
    end

    unless column_exists?(:admin_users, :profile_image_content_type)
      add_column :admin_users, :profile_image_content_type, :string
    end

    unless column_exists?(:admin_users, :profile_image_file_size)
      add_column :admin_users, :profile_image_file_size, :integer
    end

    unless column_exists?(:admin_users, :profile_image_updated_at)
      add_column :admin_users, :profile_image_updated_at, :datetime
    end
  end
end
