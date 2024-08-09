class AddProfileImageToAdminUsers < ActiveRecord::Migration[5.0]
  def change
    add_attachment :admin_users, :image
    add_column :admin_users, :profile_image_file_name, :string
    add_column :admin_users, :profile_image_content_type, :string
    add_column :admin_users, :profile_image_file_size, :integer
    add_column :admin_users, :profile_image_updated_at, :datetime
  end
end
