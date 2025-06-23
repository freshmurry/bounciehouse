class Photo < ApplicationRecord
  belongs_to :bouncehouse, optional: true

  has_many_attached :images

  # Run this in rails console (rails c)
  Photo.find_each do |photo|
    if photo.image_file_name.present? && photo.image.exists?
      photo.images.attach(
        io: File.open(photo.image.path),
        filename: photo.image_file_name,
        content_type: photo.image_content_type
      )
    end
  end
end