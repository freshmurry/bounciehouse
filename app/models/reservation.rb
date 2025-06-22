class Reservation < ApplicationRecord
  enum status: { Waiting: 0, Approved: 1, Declined: 2 }
<<<<<<< HEAD
  enum instant: { request: 0, instant: 1 }  # Add your enum definition here
=======
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)

  after_create_commit :create_notification

  belongs_to :user
  belongs_to :bouncehouse

  validates :start_date, :end_date, :bouncehouse_id, presence: true

  scope :current_week_revenue, -> (user) {
    joins(:bouncehouse)
    .where("bouncehouses.user_id = ? AND reservations.updated_at >= ? AND reservations.status = ?", user.id, 1.week.ago, statuses[:Approved])
    .order(updated_at: :asc)
  }

<<<<<<< HEAD
=======
   def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      bouncehouse_id
      user_id
      start_date
      end_date
      status
      total
      price
      created_at
      updated_at
    ]
  end
  
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
  def self.is_conflict(bouncehouse, start_date, end_date)
    bouncehouse.reservations.where("start_date < ? AND end_date > ?", end_date, start_date).exists?
  end

  def booking_fee
    return 0 if total.nil? || total.zero?
<<<<<<< HEAD
    total * 0.10 # 10% booking fee
=======
    total * 0.15 # 15% booking fee
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
  end

  private

  def create_notification
    type = self.bouncehouse.Instant? ? "New Booking" : "New Request"
    guest = User.find(self.user_id)

    Notification.create(content: "#{type} from #{guest.fullname}", user_id: self.bouncehouse.user_id)
  end
end
