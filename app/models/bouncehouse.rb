class Bouncehouse < ApplicationRecord
  enum instant: { Request: 0, Instant: 1 }

  belongs_to :user
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  has_many :reservations
  has_many :guest_reviews
  has_many :calendars

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :reverse_geocode
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

  # class GeocodeService
  #   def initialize(address)
  #     @address = address
  #   end
  
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
      "https://images.unsplash.com/photo-1531265726475-52ad60219627?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1191&q=80"
    end
  end

  def average_rating
    guest_reviews.count.zero? ? 0 : guest_reviews.average(:star).round(2).to_i
  end
end
