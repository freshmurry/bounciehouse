class BouncehousesController < ApplicationController
<<<<<<< HEAD
  before_action :set_bouncehouse, only: [:update, :edit, :destroy]
  before_action :authorized_user!, only: [:edit, :update, :destroy]
  before_action :find_bouncehouse, only: [:show, :edit, :update, :destroy, :preload_reservations, :preview_reservations]

=======
  before_action :set_bouncehouse, only: [:update, :edit, :destroy, :show, :preload_reservations, :preview_reservations]
  before_action :authorized_user!, only: [:edit, :update, :destroy]
  
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
  def index
    @bouncehouses = current_user.bouncehouses
  end

  def show
<<<<<<< HEAD
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
=======
    @bouncehouse = Bouncehouse.find(params[:id])
    @photos = @bouncehouse.photos
    @guest_reviews = Review.where(type: "GuestReview")
  end

  def new
    @bouncehouse = Bouncehouse.new(instant: 'request')
    @reservation = @bouncehouse.reservations.new
  end

  def create
    @bouncehouse = Bouncehouse.new(bouncehouse_params.except(:photos))
    if params[:bouncehouse][:photos]
      ordered_files = order_files(params[:bouncehouse][:photos], params[:photo_order])
      ordered_files.each { |file| @bouncehouse.photos.attach(file) }
    end
    if @bouncehouse.save
      redirect_to @bouncehouse, notice: "Bouncehouse created!"
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
    else
      render :new
    end
  end

  def edit
<<<<<<< HEAD
    redirect_to root_path, notice: "You don't have permission." unless current_user.id == @bouncehouse.user.id
=======
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
    @photos = @bouncehouse.photos
  end

  def update
<<<<<<< HEAD
    if @bouncehouse.update(bouncehouse_params)
      if params[:bouncehouse][:photos].present?
        params[:bouncehouse][:photos].each do |photo|
          @bouncehouse.photos.create(image: photo)
        end
      end
      redirect_to @bouncehouse, notice: 'Listing successfully updated.'
=======
    @bouncehouse = Bouncehouse.find(params[:id])
    if params[:bouncehouse][:photos]
      ordered_files = order_files(params[:bouncehouse][:photos], params[:photo_order])
      ordered_files.each { |file| @bouncehouse.photos.attach(file) }
    end
    if @bouncehouse.update(bouncehouse_params.except(:photos))
      redirect_to @bouncehouse, notice: "Bouncehouse updated!"
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
    else
      render :edit
    end
  end
<<<<<<< HEAD
  
  # ----- RESERVATIONS -----
  def preload_reservations
    @bouncehouse = Bouncehouse.find(params[:id])
    @reservations = @bouncehouse.reservations.where("start_date <= ? AND end_date >= ?", Date.today, Date.today)

    # We include special dates in the response (if applicable)
    special_dates = @bouncehouse.special_dates

    respond_to do |format|
      format.json { render json: { reservations: @reservations, special_dates: special_dates } }
=======

  # ----- RESERVATIONS -----
  def preload_reservations
    begin
      @reservations = @bouncehouse.reservations.where("start_date <= ? AND end_date >= ?", Date.today, Date.today)

      respond_to do |format|
        format.json { render json: { reservations: @reservations } }
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
    end
  end

  def preview_reservations
<<<<<<< HEAD
    @bouncehouse = Bouncehouse.find(params[:id])
    start_date = params[:start_date]
    end_date = params[:end_date]
    
    # Checking if there is a conflict with the reservation
    @conflict = Reservation.is_conflict(@bouncehouse, start_date, end_date)

    respond_to do |format|
      format.json { render json: { conflict: @conflict } }
    end
  end
  
=======
    begin
      start_date = params[:start_date]
      end_date = params[:end_date]
      @conflict = Reservation.is_conflict(@bouncehouse, start_date, end_date)

      respond_to do |format|
        format.json { render json: { conflict: @conflict } }
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
  def destroy
    @bouncehouse.destroy
    redirect_to bouncehouses_url, notice: 'Bouncehouse deleted successfully.'
  end
<<<<<<< HEAD
  
  private

  def find_bouncehouse
=======

  private

  def set_bouncehouse
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
    @bouncehouse = Bouncehouse.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Bouncehouse not found."
    redirect_to root_path
  end

<<<<<<< HEAD
  def set_bouncehouse
    @bouncehouse = Bouncehouse.find_by(id: params[:id])
  end

=======
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
  def authorized_user!
    redirect_to root_path, alert: "You don't have permission" unless current_user.id == @bouncehouse.user_id
  end

<<<<<<< HEAD
  def bouncehouse_params
    params.require(:bouncehouse).permit(:bouncehouse_type, :time_limit, :pickup_type, :instant, :listing_name, :description, :address, :latitude, :longitude, :price, :is_heated, :is_slide, 
      :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active, photos_attributes: [:id, :image, :_destroy])
  end
end
=======
  def is_ready_bouncehouse
    @bouncehouse.bouncehouse_type.present? && @bouncehouse.listing_name.present? && @bouncehouse.description.present? && @bouncehouse.address.present? && @bouncehouse.price.present?
  end
  
  def bouncehouse_params
    params.require(:bouncehouse).permit(:listing_name, :description, :price, :address, :active, :bouncehouse_type, :time_limit, :pickup_type, :instant, :is_heated, :is_slide, :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, photos: [])
  end

  def order_files(files, order_string)
    return files unless order_string.present?
    order = order_string.split(",").map(&:to_i)
    order.map { |i| files[i] }
  end
end
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
