class RemovePhotoIdFromBouncehouses < ActiveRecord::Migration[7.0]
  def change
    remove_column :bouncehouses, :photo_id, :integer
  end
end
