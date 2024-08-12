class AdminUser < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_attached_file :profile_image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\z/

  def self.after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      Rails.application.routes.url_helpers.authenticated_admin_root_path
    else
      super
    end
  end
end
