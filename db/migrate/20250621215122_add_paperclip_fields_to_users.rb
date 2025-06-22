class AddPaperclipFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :image_file_name, :string unless column_exists?(:users, :image_file_name)
    add_column :users, :image_content_type, :string unless column_exists?(:users, :image_content_type)
    add_column :users, :image_file_size, :integer unless column_exists?(:users, :image_file_size)
    add_column :users, :image_updated_at, :datetime unless column_exists?(:users, :image_updated_at)
  end
end
