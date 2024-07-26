class Review < ApplicationRecord
  belongs_to :bouncehouse
  belongs_to :reservation
  belongs_to :guest, class_name: "User" # Assuming guest is the reviewer
  belongs_to :host, class_name: "User", optional: true # Assuming host is the owner of the bouncehouse

  # Validations
  validates :bouncehouse, presence: true
  validates :reservation, presence: true
  validates :guest, presence: true
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 } # Assuming ratings are between 1 and 5

  validate :user_has_reservation_for_bouncehouse
  validate :reservation_date_passed

  private

  def user_has_reservation_for_bouncehouse
    if reservation.user_id != guest.id || reservation.bouncehouse_id != bouncehouse.id
      errors.add(:base, "User must have a valid reservation for this bounce house to leave a review.")
    end
  end

  def reservation_date_passed
    if reservation.reservation_date > Date.today
      errors.add(:base, "You cannot leave a review until after your scheduled reservation date.")
    end
  end
end
