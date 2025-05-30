class AddAttachmentImageToUser < ActiveRecord::Migration[5.0]
  def self.up
    change_table :users do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :users, :image
  end
end