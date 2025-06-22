<<<<<<< HEAD
class AddProfileImageToAdminUsers < ActiveRecord::Migration[5.0]
  def change
    add_attachment :admin_users, :profile_image
=======
class AddProfileImageToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :profile_image, :string
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
  end
end