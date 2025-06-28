class UpdateImageColumns < ActiveRecord::Migration[7.0]
  def up
    User.find_each do |user|
      # Skip if the user doesn't have an image method or the image is nil
      next unless user.respond_to?(:image) && user.image.present? && user.image.respond_to?(:attached?) && user.image.attached?

      # Download the image file
      file_data = user.image.blob.download

      # Add your logic here, e.g. storing the file content, re-attaching, etc.
      # Example: user.update!(legacy_image_backup: file_data)
    end
  end

  def down
    # Add rollback logic if needed
  end
end
