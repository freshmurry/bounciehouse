class Bouncehouse < ApplicationRecord
  enum instant: { Request: 1, Instant: 0 }

  belongs_to :user

  # Use the Photo model association, not direct Active Storage
  has_many :photos, dependent: :destroy

  has_many :reservations
  has_many :guest_reviews
  has_many :calendars

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :reverse_geocode

  has_many :favorites
  has_many :favorited_by, through: :favorites, source: :user

  class GeocodeService
    def initialize(address)
      @address = address
    end
  end

  # Use the first photo's image as the cover photo
  def cover_photo(size = :medium)
    first_photo = photos.joins(:images_attachments).first
    if first_photo&.images&.attached?
      size_options = { medium: [400, 300], thumb: [100, 100] }
      first_photo.images.first.variant(resize_to_limit: size_options[size] || size_options[:medium]).processed
    else
      "blank.jpg"
    end
  end

  def average_rating
    guest_reviews.average(:star)&.round(2) || 0
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "active",
      "address",
      "bouncehouse_type",
      "created_at",
      "description",
      "id",
      "instant",
      "is_basketball_hoop",
      "is_heated",
      "is_lighting",
      "is_slide",
      "is_speaker",
      "is_sprinkler",
      "is_wall_climb",
      "is_waterslide",
      "latitude",
      "listing_name",
      "longitude",
      "pickup_type",
      "price",
      "time_limit",
      "tip",
      "updated_at",
      "user_id"
    ]
  end
end
