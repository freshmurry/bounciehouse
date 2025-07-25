class Bouncehouse < ApplicationRecord
  enum instant: { Request: 1, Instant: 0 }

  belongs_to :user, required: false
  has_many :photos, dependent: :destroy
  
  has_many :reservations, dependent: :destroy
  
  has_many :guest_reviews, dependent: :destroy
  has_many :calendars, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user
  
  geocoded_by :address
  # Uncomment if you only want to geocode when address changes:
  # after_validation :geocode, if: :address_changed?
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :reverse_geocode

  validates :bouncehouse_type, presence: true
  validates :time_limit, presence: true
  
  class GeocodeService
    def initialize(address)
      @address = address
    end
  end

  # Returns the URL for the cover photo (first photo) or a default image
  def cover_photo(size = :medium)
    if photos.any? && photos.first.image.present?
      url = photos.first.image.url(size)
      url = "https:#{url}" if url.present? && url.start_with?("//")
      url.presence || ActionController::Base.helpers.asset_path('blank.jpg')
    else
      ActionController::Base.helpers.asset_path('blank.jpg')
    end
  end


  def self.ransackable_attributes(auth_object = nil)
    %w[
      active address bouncehouse_type created_at description id instant
      is_basketball_hoop is_heated is_lighting is_slide is_speakers
      is_sprinkler is_wall_climb is_waterslide latitude listing_name
      longitude pickup_type price time_limit tip updated_at user_id
    ]
  end

  def average_rating
    guest_reviews.average(:star)&.round(2) || 0
  end
end
