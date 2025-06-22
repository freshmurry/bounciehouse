class Bouncehouse < ApplicationRecord
<<<<<<< HEAD
  enum instant: { Request: 0, Instant: 1 }
  enum instant: { request: 'request', instant: 'instant' }

  belongs_to :user
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true
=======
  enum instant: { Request: 1, Instant: 0 }

  belongs_to :user
  has_many_attached :photos
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)

  has_many :reservations
  has_many :guest_reviews
  has_many :calendars

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :reverse_geocode
<<<<<<< HEAD
  # after_validation :geocode, if: :address_changed?

  # validates :bouncehouse_type, :time_limit, :pickup_type, :price, :listing_name, :description, :address, presence: true
  # validates :listing_name, :description, length: { maximum: 50 }
  # validates :price, numericality: { greater_than: 0 } # Ensure price is positive

  # def fetch_geocode_data(address)
  #   url = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(address)}&key=AIzaSyCV181duH-y_7oW373c8YSHpUURXjKMKbk")
  #   response = Net::HTTP.get(url)
  #   data = JSON.parse(response)

  #   if data["status"] == "OK"
  #     # Process and store data
  #   else
  #     # Handle error
  #   end
  # end
=======

  has_many :favorites
  has_many :favorited_by, through: :favorites, source: :user
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)

  class GeocodeService
    def initialize(address)
      @address = address
    end
  end
<<<<<<< HEAD
  #   def fetch_data
  #     url = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(@address)}&key=AIzaSyCV181duH-y_7oW373c8YSHpUURXjKMKbk")
  #     response = Net::HTTP.get(url)
  #     data = JSON.parse(response)
  
  #     if data["status"] == "OK"
  #       data["results"]
  #     else
  #       raise "Error: #{data['status']}"
  #     end
  #   end
  # end

  # Bouncehouse.where(latitude: nil, longitude: nil).find_each do |bouncehouse|
  #   bouncehouse.geocode
  #   bouncehouse.save
  # end
  
  # def cover_photo(size)
  #   photos.first&.image&.url(size) || ActionController::Base.helpers.asset_path("blank.jpg")
  # end

  # def geocode
  #   super
  #   Rails.logger.debug "Geocoding #{self.address}"
  #   Rails.logger.debug "Latitude: #{self.latitude}, Longitude: #{self.longitude}"
  # end

  def cover_photo(size)
    if self.photos.length > 0
      self.photos[0].image.url(size)
    else

=======

  def cover_photo(size = :medium)
    if photos.attached?
      size_options = { medium: [400, 300], thumb: [100, 100] }
      photos.first.variant(resize_to_limit: size_options[size] || size_options[:medium]).processed
    else
      "blank.jpg"
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
    end
  end

  def average_rating
<<<<<<< HEAD
    guest_reviews.count.zero? ? 0 : guest_reviews.average(:star).round(2).to_i
=======
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
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
  end
end
