class User < ApplicationRecord
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: 'blank.jpg'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Validations
  validates :fullname, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true

  # Associations
  has_many :bouncehouses, dependent: :delete_all
  has_many :reservations
  has_many :guest_reviews, class_name: "GuestReview", foreign_key: "guest_id"
  has_many :host_reviews, class_name: "HostReview", foreign_key: "host_id"
  has_many :notifications
  has_one :setting, dependent: :destroy

  # Callbacks
  after_create :add_setting

  # Methods
  def add_setting
    Setting.create(user: self, enable_sms: true, enable_email: true)
  end

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    if user
      user
    else
      create(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        fullname: auth.info.name,
        image: auth.info.image
      ).tap { |user| user.skip_confirmation! }
    end
  end

  def generate_pin
    update(pin: SecureRandom.hex(2), phone_verified: false)
  end

  def send_pin
    client = Twilio::REST::Client.new
    client.messages.create(
      from: '+3125488878',
      to: phone_number,
      body: "Your pin is #{pin}"
    )
  end

  def verify_pin(entered_pin)
    update(phone_verified: true) if pin == entered_pin
  end

  def is_active_host
    merchant_id.present?
  end
end

# Strict password security measures. *Uncomment when app goes live!*
  # validates :password, :presence => true,
  #                   :on => :create,
  #                   :format => {:with => /\A.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\!\@\#\$\%\^\&\+\=]).*\Z/ }