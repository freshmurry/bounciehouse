class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @bouncehouses = @user.bouncehouses
    @guest_reviews = Review.where(type: "GuestReview", host_id: @user.id)
    @host_reviews = Review.where(type: "HostReview", guest_id: @user.id)
  end

  def update_phone_number
    if current_user.update(user_params)
      current_user.generate_pin
      current_user.send_pin
      redirect_to edit_user_registration_path, notice: "Phone number updated and PIN sent."
    else
      redirect_to edit_user_registration_path, alert: "Failed to update phone number."
    end
  end

  def verify_phone_number
    if current_user.verify_pin(params[:user][:pin])
      flash[:notice] = "Your phone number is verified."
    else
      flash[:alert] = "Verification failed. Please check your PIN and try again."
    end

    redirect_to edit_user_registration_path

  rescue Exception => e
    redirect_to edit_user_registration_path, alert: "#{e.message}"
  end

  def payment
  end

  def payout
    if !current_user.merchant_id.blank?
      account = Stripe::Account.retrieve(current_user.merchant_id)
      @login_link = account.login_links.create()
    end
  end

  def add_card
    begin
      customer = if current_user.stripe_id.present?
                   Stripe::Customer.retrieve(current_user.stripe_id)
                 else
                   Stripe::Customer.create(email: current_user.email).tap do |new_customer|
                     current_user.update(stripe_id: new_customer.id)
                   end
                 end

      customer.sources.create(source: params[:stripeToken])
      flash[:notice] = "Your card has been saved."
      redirect_to payment_method_path
    rescue Stripe::CardError => e
      flash[:alert] = "Card error: #{e.message}"
      redirect_to payment_method_path
    rescue => e
      flash[:alert] = "An unexpected error occurred: #{e.message}"
      redirect_to payment_method_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:phone_number, :pin)
    end
end
