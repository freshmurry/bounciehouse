module ApplicationHelper
  # def image(user)
  #   if user.image.exists? # checks if Paperclip image is attached
  #     user.image.url(:thumb) # or :medium or :original
  #   elsif user.uid.present? # Facebook user id for profile picture
  #     "https://graph.facebook.com/#{user.uid}/picture?type=large"
  #   elsif user.email.present?
  #     gravatar_id = Digest::MD5.hexdigest(user.email.strip.downcase)
  #     "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identicon&s=150"
  #   else
  #     'blank.jpg' # fallback image path in assets
  #   end
  # end

  def image(user)
    if user.image
      "https://graph.facebook.com/#{user.uid}/picture?type=large"
    elsif
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
    else
      'profile-photo.png'
    end
  end

  # private

  # def gravatar_exists?(gravatar_url)
  #   response = Net::HTTP.get_response(URI.parse(gravatar_url))
  #   response.code == "200"
  # rescue StandardError => e
  #   Rails.logger.error "Gravatar check failed: #{e.message}"
  #   false
  # end

  def stripe_express_path
    if Rails.env.development?
      "https://connect.stripe.com/express/oauth/authorize?redirect_uri=http://localhost:3000/auth/stripe_connect/callback&client_id=ca_Bz12s2Z5ijkGknATCnWx9EmDZIvGMf0e&state={STATE_VALUE}"
    else
      "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://bounciehouse.com/auth/stripe_connect/callback&client_id=ca_Hms44phcleeZY7RlWjYEQM5K864Cfb1Q&state={STATE_VALUE}"
    end
  end
end
