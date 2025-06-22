class Photo < ApplicationRecord
<<<<<<< HEAD
  belongs_to :bouncehouse
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates :image, presence: true
=======
  belongs_to :bouncehouse, optional: true

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
end
