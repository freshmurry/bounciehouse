class AdminUser < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

<<<<<<< HEAD
  has_attached_file :profile_image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\z/
  
=======
  # has_attached_file :profile_image, styles: { medium: "300x300>", thumb: "100x100>" }
  has_one_attached :profile_image
  # validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\z/
  validates_acceptance_of :profile_image, allow_blank: true
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
  validates :email, presence: true, uniqueness: true

  def self.after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      Rails.application.routes.url_helpers.authenticated_admin_root_path
    else
      super
    end
  end
end
