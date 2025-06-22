class Photo < ApplicationRecord
  belongs_to :bouncehouse, optional: true

  has_many_attached :images
end