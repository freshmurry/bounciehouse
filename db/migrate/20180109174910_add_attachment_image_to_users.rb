class AddAttachmentImageToUsers < ActiveRecord::Migration[7.0]
  def self.up
    change_table :users do |t|
      t.references :image
    end
  end

  def self.down
    remove_attachment :users, :image
  end
end