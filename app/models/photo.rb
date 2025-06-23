class Photo < ApplicationRecord
  belongs_to :bouncehouse
  has_attached_file :image # Paperclip
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  has_many_attached :images # Active Storage
end