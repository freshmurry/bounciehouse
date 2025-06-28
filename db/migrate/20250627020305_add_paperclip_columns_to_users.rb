class AddPaperclipColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :cover_photo_file_name, :string
    add_column :users, :cover_photo_content_type, :string
    add_column :users, :cover_photo_file_size, :integer
    add_column :users, :cover_photo_updated_at, :datetime

    add_column :bouncehouses, :cover_photo_file_name, :string
    add_column :bouncehouses, :cover_photo_content_type, :string
    add_column :bouncehouses, :cover_photo_file_size, :integer
    add_column :bouncehouses, :cover_photo_updated_at, :datetime
  end
end
