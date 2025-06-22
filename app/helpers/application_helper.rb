require 'net/http'

module ApplicationHelper
  def image(user)
    user.image.attached? ? url_for(user.image) : "blank.jpg"
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
      "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://bounciehouse.com/auth/stripe_connect/callback&client_id=ca_Hms44phcleeZY7RlWjYEQM5K864Cfb1Q&state={STATE_VALUE}"
    end
  end
end
