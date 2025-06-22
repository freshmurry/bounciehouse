class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @bouncehouse = Bouncehouse.find(params[:bouncehouse_id])
    # Prevent users from favoriting their own listing
    if @bouncehouse.user_id == current_user.id
      respond_to do |format|
        format.html { redirect_back fallback_location: bouncehouses_path, alert: "You cannot favorite your own listing." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("favorite_button_#{@bouncehouse.id}", partial: "favorites/favorite_button", locals: { bouncehouse: @bouncehouse }) }
      end
      return
    end

    @favorite = current_user.favorites.create(bouncehouse: @bouncehouse)
    respond_to do |format|
      format.html { redirect_back fallback_location: bouncehouses_path }
      format.turbo_stream
    end
  end

  def destroy
    @bouncehouse = Bouncehouse.find(params[:bouncehouse_id])
    @favorite = current_user.favorites.find_by(bouncehouse: @bouncehouse)
    @favorite.destroy if @favorite
    respond_to do |format|
      format.html { redirect_back fallback_location: bouncehouses_path }
      format.turbo_stream
    end
  end
end
