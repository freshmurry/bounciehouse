class Setting < ApplicationRecord
  belongs_to :user

  # Validations
  validates :user_id, presence: true
  validates :enable_sms, inclusion: { in: [true, false] }
  validates :enable_email, inclusion: { in: [true, false] }

  validates :user_id, uniqueness: true

  def sms_enabled?
    enable_sms
  end

  def email_enabled?
    enable_email
  end
end
