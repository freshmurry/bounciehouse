class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :bouncehouse
  validates :user_id, uniqueness: { scope: :bouncehouse_id }
end
