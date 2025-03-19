class BouncehousesController < ApplicationController
  before_action :set_bouncehouse, only: [:update, :edit, :destroy]
  before_action :authorized_user!, only: [:edit, :update, :destroy]
  before_action :find_bouncehouse, only: [:show, :edit, :update, :destroy, :preload_reservations, :preview_reservations]

  def index
    @bouncehouses = current_user.bouncehouses
  end

  def show
    @photos = @bouncehouse.photos
    @guest_reviews = Review.where(type: "GuestReview", bouncehouse_id: @bouncehouse.id)
    @reservation = Reservation.new
  end

  def new
    @bouncehouse = Bouncehouse.new(instant: 'request')  # Set 'request' as the default for new bouncehouses
    @reservation = @bouncehouse.reservations.new  # Initialize @reservation here
  end

  def create
    @bouncehouse = current_user.bouncehouses.build(bouncehouse_params)

    if @bouncehouse.save
      if params[:images]
        params[:images].each do |image|
          @bouncehouse.photos.create(image: image)
        end
      end

      @photos = @bouncehouse.photos
      redirect_to bouncehouse_path(@bouncehouse), notice: "Bouncehouse successfully created."
    else
      render :new
    end
  end

  def edit
    redirect_to root_path, notice: "You don't have permission." unless current_user.id == @bouncehouse.user.id
    @photos = @bouncehouse.photos
  end

  def update
    if @bouncehouse.update(bouncehouse_params)
      if params[:bouncehouse][:photos].present?
        params[:bouncehouse][:photos].each do |photo|
          @bouncehouse.photos.create(image: photo)
        end
      end
      redirect_to @bouncehouse, notice: 'Listing successfully updated.'
    else
      render :edit
    end
  end
  
  # ----- RESERVATIONS -----
  def preload_reservations
    @bouncehouse = Bouncehouse.find(params[:id])
    @reservations = @bouncehouse.reservations.where("start_date <= ? AND end_date >= ?", Date.today, Date.today)

    # We include special dates in the response (if applicable)
    special_dates = @bouncehouse.special_dates

    respond_to do |format|
      format.json { render json: { reservations: @reservations, special_dates: special_dates } }
    end
  end

  def preview_reservations
    @bouncehouse = Bouncehouse.find(params[:id])
    start_date = params[:start_date]
    end_date = params[:end_date]
    
    # Checking if there is a conflict with the reservation
    @conflict = Reservation.is_conflict(@bouncehouse, start_date, end_date)

    respond_to do |format|
      format.json { render json: { conflict: @conflict } }
    end
  end
  
  def destroy
    @bouncehouse.destroy
    redirect_to bouncehouses_url, notice: 'Bouncehouse deleted successfully.'
  end
  
  private

  def find_bouncehouse
    @bouncehouse = Bouncehouse.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Bouncehouse not found."
    redirect_to root_path
  end

  def set_bouncehouse
    @bouncehouse = Bouncehouse.find_by(id: params[:id])
  end

  def authorized_user!
    redirect_to root_path, alert: "You don't have permission" unless current_user.id == @bouncehouse.user_id
  end

  def bouncehouse_params
    params.require(:bouncehouse).permit(:bouncehouse_type, :time_limit, :pickup_type, :instant, :listing_name, :description, :address, :latitude, :longitude, :price, :is_heated, :is_slide, 
      :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active, photos_attributes: [:id, :image, :_destroy])
  end
end
