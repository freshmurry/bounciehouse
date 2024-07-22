require 'net/http'

module ApplicationHelper
  # def image(user)
  #   if user.image
  #     "https://graph.facebook.com/#{user.uid}/picture?type=large"
  #   elsif
  #     gravatar_id = Digest::MD5::hexdigest(user.email).downcase
  #     "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
  #   else
  #     'blank.jpg'
  #   end
  # end
  
  def image(user)
    if user.email.present?
      # Fallback to Gravatar if the email is present
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=404&s=150"

      # Check if Gravatar image exists
      if gravatar_exists?(gravatar_url)
        gravatar_url
      elsif user.image.present?
        # Check if the user has uploaded their own image
        user.image.url
      else
        # Fallback to default blank image
        'blank.jpg'
      end
    else
      # Fallback to default blank image if no email is present
      'blank.jpg'
    end
  end

  private

  def gravatar_exists?(gravatar_url)
    response = Net::HTTP.get_response(URI.parse(gravatar_url))
    response.code == "200"
  rescue
     false
  end

  # def avatar_url(user)
  #   if user.image
  #     "https://graph.facebook.com/#{user.uid}/picture?type=large"
  #   else  
  #     gravatar_id = Digest::MD5::hexdigest(user.email).downcase
  #     "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
  #   end
  # end
  
  def stripe_express_path
  # ----- TEST -----
  # "https://connect.stripe.com/express/oauth/authorize?redirect_uri=http://localhost:3000/auth/stripe_connect/callback&client_id=ca_Bz12s2Z5ijkGknATCnWx9EmDZIvGMf0e&state={STATE_VALUE}"
  # "https://connect.stripe.com/express/oauth/authorize?redirect_uri=http://localhost:3000/auth/stripe_connect/callback&client_id=ca_Bz12s2Z5ijkGknATCnWx9EmDZIvGMf0e&state=read_write"

  # ---- LIVE ----
  "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://bouncyhouse.herokuapp.com/auth/stripe_connect/callback&client_id=ca_Hms44phcleeZY7RlWjYEQM5K864Cfb1Q&state={STATE_VALUE}"
  # "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://bouncehouse.com/auth/stripe_connect/callback&client_id=ca_Bz129rceytBvxCIxgLptuWQeV6JayofE&state=read_write"

  end
end