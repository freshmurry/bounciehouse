class RemovePhotoColumnsFromBouncehouses < ActiveRecord::Migration[7.0]
  def change
    remove_column :bouncehouses, :photo_id, :integer if column_exists?(:bouncehouses, :photo_id)
    remove_column :bouncehouses, :photos, :string if column_exists?(:bouncehouses, :photos)
  end
end 