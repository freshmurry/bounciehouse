class Bouncehouse < ApplicationRecord
  enum instant: { Request: 1, Instant: 0 }

  belongs_to :user, required: false
  has_many :photos
  has_many :reservations
  
  has_many :guest_reviews
  has_many :calendars
  has_many :favorites
  has_many :favorited_by, through: :favorites, source: :user
  
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :reverse_geocode

  validates :bouncehouse_type, presence: true
  validates :time_limit, presence: true

  class GeocodeService
    def initialize(address)
      @address = address
    end
  end

  def cover_photo(size)
    if self.photos.length > 0
      self.photos[0].image.url(size)
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
      "is_speakers",
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
