class Bouncehouse < ApplicationRecord
  enum instant: {Request: 0, Instant: 1}
  
  belongs_to :user
  has_many :photos
  has_many :reservations
  has_many :guest_reviews
  has_many :calendars
    
  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  
  validates :bouncehouse_type, presence: true
  validates :time_limit, presence: true
  validates :pickup_type, presence: true
  validates :price, presence: true
  validates :listing_name, presence: true, length: {maximum: 50}
  validates :description, presence: true, length: {maximum: 50}
  validates :address, presence: true
  # validates :price, numericality: { greater_than_or_equal_to: 0 }

  # def cover_photo(size)
  #   if self.photos.present?
  #     self.photos.first.image.url(size)
  #   else
  #     ActionController::Base.helpers.asset_path("blank.jpg")
  #   end
  # end
  
  def average_rating
    guest_reviews.count == 0 ? 0 : guest_reviews.average(:star).round(2).to_i
  end
end