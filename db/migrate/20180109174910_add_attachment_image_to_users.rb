<<<<<<< HEAD
class AddAttachmentImageToUsers < ActiveRecord::Migration[5.0]
  def self.up
    change_table :users do |t|
      t.attachment :image
=======
class AddAttachmentImageToUsers < ActiveRecord::Migration[7.0]
  def self.up
    change_table :users do |t|
      t.references :image
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
    end
  end

  def self.down
    remove_attachment :users, :image
  end
end