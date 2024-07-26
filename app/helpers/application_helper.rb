require 'net/http'

module ApplicationHelper
  def image(user)
    if user.email.present?
      gravatar_id = Digest::MD5.hexdigest(user.email).downcase
      gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=404&s=150"

      if gravatar_exists?(gravatar_url)
        gravatar_url
      elsif user.image.present?
        user.image.url
      else
        'blank.jpg'
      end
    else
      'blank.jpg'
    end
  end

  private

  def gravatar_exists?(gravatar_url)
    response = Net::HTTP.get_response(URI.parse(gravatar_url))
    response.code == "200"
  rescue StandardError => e
    Rails.logger.error "Gravatar check failed: #{e.message}"
    false
  end

  def stripe_express_path
    if Rails.env.development?
      "https://connect.stripe.com/express/oauth/authorize?redirect_uri=http://localhost:3000/auth/stripe_connect/callback&client_id=ca_Bz12s2Z5ijkGknATCnWx9EmDZIvGMf0e&state={STATE_VALUE}"
    else
      "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://bouncyhouse.herokuapp.com/auth/stripe_connect/callback&client_id=ca_Hms44phcleeZY7RlWjYEQM5K864Cfb1Q&state={STATE_VALUE}"
    end
  end
end
