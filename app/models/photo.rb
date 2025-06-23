class Photo < ApplicationRecord
  belongs_to :bouncehouse
  has_many_attached :images

  # Validation is not necessary for ActiveStorage since it validates automatically for content types
  # If you need to validate the image type, you can do so with a custom validation:
  validate :correct_image_type

  private

  def correct_image_type
    images.each do |image|
      unless image.content_type.starts_with?('image/')
        errors.add(:images, 'must be an image')
      end
    end
  end
end
