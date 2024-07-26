class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, alert: "Could not authenticate you via Facebook."
    end
  end

  def stripe_connect
    auth_data = request.env["omniauth.auth"]
    @user = current_user

    if @user.persisted?
      @user.update(merchant_id: auth_data.uid)

      if @user.merchant_id.present?
        begin
          # Update Payout Schedule
          account = Stripe::Account.retrieve(@user.merchant_id)
          account.payout_schedule.delay_days = 7
          account.payout_schedule.interval = "daily"
          account.save

          logger.debug "Stripe account updated: #{account}"
        rescue Stripe::StripeError => e
          logger.error "Stripe error: #{e.message}"
          flash[:alert] = "Failed to update Stripe account: #{e.message}"
        end

        sign_in_and_redirect @user, event: :authentication
        flash[:notice] = "Stripe Account Created and Connected" if is_navigational_format?
      else
        flash[:alert] = "Stripe account not created."
        redirect_to dashboard_path
      end
    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      redirect_to dashboard_path, alert: "Could not authenticate you via Stripe Connect."
    end
  end

  def failure
    redirect_to root_path, alert: "Authentication failed."
  end
end
