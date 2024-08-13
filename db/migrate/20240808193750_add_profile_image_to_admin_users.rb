class AddProfileImageToAdminUsers < ActiveRecord::Migration[5.0]
  def change
    add_attachment :admin_users, :profile_image
  end
end