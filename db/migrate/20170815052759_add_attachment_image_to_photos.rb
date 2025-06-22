class AddAttachmentImageToPhotos < ActiveRecord::Migration[5.0]
  def self.up
    change_table :photos do |t|
<<<<<<< HEAD
      t.attachment :image
=======
      t.references :image
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
    end
  end

  def self.down
    remove_attachment :photos, :image
  end
end