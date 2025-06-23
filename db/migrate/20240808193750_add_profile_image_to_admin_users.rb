class AddProfileImageToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :profile_image, :string
  end
end