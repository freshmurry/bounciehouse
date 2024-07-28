class BouncehousesController < ApplicationController
  before_action :set_bouncehouse, only: [:update, :edit]


  def index
    @bouncehouses = current_user.bouncehouses
  end

  def show
    @bouncehouse = Bouncehouse.find(params[:id])
    @photos = @bouncehouse.photos
    @guest_reviews = Review.where(type: "GuestReview", bouncehouse_id: @bouncehouse.id)
    @reservation = Reservation.new
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Bouncehouse not found."
    redirect_to root_path
  end

  def new
    @bouncehouse = current_user.bouncehouses.build
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
      redirect_to bouncehouse_path(@bouncehouse), notice: "Saved..."
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
      if params[:bouncehouse][:photos]
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
    
    respond_to do |format|
      format.json { render json: @reservations }
    end
  end

  def preview_reservations
    @bouncehouse = Bouncehouse.find(params[:id])
    start_date = params[:start_date]
    end_date = params[:end_date]
    @conflict = Reservation.is_conflict(@bouncehouse, start_date, end_date)

    respond_to do |format|
      format.json { render json: { conflict: @conflict } }
    end
  end
  
  def destroy
    @bouncehouse.destroy
    redirect_to root_path, notice: "Deleted..."
  end
  
  private

  def set_bouncehouse
    @bouncehouse = Bouncehouse.find(params[:id])
  end

  def authorized_user!
    redirect_to root_path, alert: "You don't have permission" unless current_user.id == @bouncehouse.user_id
  end

  def bouncehouse_params
    params.require(:bouncehouse).permit(:bouncehouse_type, :time_limit, :pickup_type, :instant, :listing_name, :description, :address, :price, :is_heated, :is_slide, 
      :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active, photos_attributes: [:id, :image, :_destroy])
  end
end
