class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :update_phone_number, :verify_phone_number, :payment, :payout, :add_card]
  before_action :set_user, only: [:show, :update]

  def show
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
  end

  def payment
    # Implementation for payment view goes here
  end

  def payout
    if current_user.merchant_id.present?
      account = Stripe::Account.retrieve(current_user.merchant_id)
      @login_link = account.login_links.create
    else
      flash[:alert] = "No merchant account found. Please connect your Stripe account first."
      redirect_to payment_path
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
      redirect_to payment_path
    rescue Stripe::CardError => e
      flash[:alert] = "Card error: #{e.message}"
      redirect_to payment_path
    rescue => e
      flash[:alert] = "An unexpected error occurred: #{e.message}"
      redirect_to payment_path
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Profile updated successfully."
      redirect_to @user
    else
      flash[:alert] = "Failed to update profile."
      render :edit
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:phone_number, :pin, :image) # Adjusted to handle image file upload properly
    end
end
