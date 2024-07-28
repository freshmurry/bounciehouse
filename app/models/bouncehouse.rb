class Bouncehouse < ApplicationRecord
  enum instant: { Request: 0, Instant: 1 }

  belongs_to :user
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  has_many :reservations
  has_many :guest_reviews
  has_many :calendars

  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? }

  validates :bouncehouse_type, :time_limit, :pickup_type, :price, :listing_name, :description, :address, presence: true
  validates :listing_name, :description, length: { maximum: 50 }
  validates :price, numericality: { greater_than: 0 } # Ensure price is positive

  def cover_photo(size)
    photos.first&.image&.url(size) || ActionController::Base.helpers.asset_path("blank.jpg")
  end

  def average_rating
    guest_reviews.count.zero? ? 0 : guest_reviews.average(:star).round(2).to_i
  end
end
