class Calendar < ApplicationRecord
  enum status: { available: 0, not_available: 1 }

  validates :day, presence: true
  belongs_to :bouncehouse
end
