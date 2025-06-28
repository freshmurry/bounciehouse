class PopulatePaperclipColumns < ActiveRecord::Migration[7.0]
  def up
    User.all.each do |user|
      if user.cover_photo_file_name.present?
        user.update(
          cover_photo_file_name: user.cover_photo_file_name,
          cover_photo_content_type: user.cover_photo_content_type,
          cover_photo_file_size: user.cover_photo_file_size,
          cover_photo_updated_at: user.cover_photo_updated_at
        )
      end
    end

    Bouncehouse.all.each do |bouncehouse|
      if bouncehouse.cover_photo_file_name.present?
        bouncehouse.update(
          cover_photo_file_name: bouncehouse.cover_photo_file_name,
          cover_photo_content_type: bouncehouse.cover_photo_content_type,
          cover_photo_file_size: bouncehouse.cover_photo_file_size,
          cover_photo_updated_at: bouncehouse.cover_photo_updated_at
        )
      end
    end
  end
end