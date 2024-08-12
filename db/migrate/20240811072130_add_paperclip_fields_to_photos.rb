class AddPaperclipFieldsToPhotos < ActiveRecord::Migration[5.0]
  def change
    # Only add columns if they do not already exist
    unless column_exists?(:photos, :image_file_name)
      add_column :photos, :image_file_name, :string
    end

    unless column_exists?(:photos, :image_content_type)
      add_column :photos, :image_content_type, :string
    end

    unless column_exists?(:photos, :image_file_size)
      add_column :photos, :image_file_size, :integer
    end

    unless column_exists?(:photos, :image_updated_at)
      add_column :photos, :image_updated_at, :datetime
    end
  end
end
