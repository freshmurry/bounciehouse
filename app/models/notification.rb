class Notification < ApplicationRecord
  after_create_commit { NotificationJob.perform_later self }
  has_many :notifications, dependent: :destroy
  belongs_to :user
end