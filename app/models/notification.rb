class Notification < ApplicationRecord
  after_create_commit { NotificationJob.perform_later self }
  has_many :notifications, dependent: :destroy
  belongs_to :user

  validates :content, presence: true
  validates :user_id, presence: true

  def formatted_content
    "#{created_at.strftime("%Y-%m-%d %H:%M")} - #{content}"
  end
end