class BouncehousesController < ApplicationController
  before_action :set_bouncehouse, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show, :preload, :preview]
  before_action :is_authorized, only: [:listing, :pricing, :description, :photo_upload, :location, :updat, :destroy]
  
  def index
    @bouncehouses = current_user.bouncehouses
  end

  def new
    @bouncehouse = current_user.bouncehouses.build
  end

  def create
    # This code makes host register with Stripe first. We want people to create their listing without having to signup with Stripe first.
    # if !current_user.is_active_host
    #   return redirect_to payout_path, alert: "Please Connect to Stripe Express first."
    # end
    
    @bouncehouse = current_user.bouncehouses.build(bouncehouse_params)
    if @bouncehouse.save
      redirect_to listing_bouncehouse_path(@bouncehouse), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong..."
      render :new
    end
  end

  def show
    @bouncehouse = Bouncehouse.find(params[:id])
    @photos = @bouncehouse.photos
    @guest_reviews = Review.where(type: "GuestReview")
  end
  
  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @bouncehouse.photos
  end

  def location
  end

  def update
    @bouncehouse = Bouncehouse.find(params[:id])
    new_params = bouncehouse_params

    if @bouncehouse.update(new_params)
      if params[:bouncehouse][:photos]
        params[:bouncehouse][:photos].reject(&:blank?).each do |photo|
          @bouncehouse.photos.create(image: photo)
        end
      end
      flash[:notice] = "Saved..."
      redirect_to @bouncehouse
    else
      flash[:alert] = "Something went wrong..."
      render :edit
    end
  end

  def destroy
    @bouncehouse = Bouncehouse.find(params[:id])
    @bouncehouse.destroy

    # redirect_back(fallback_location: request.referer, notice: "Deleted...!")
    redirect_to root_path, notice: "Deleted..."
  end
  
  #---- RESERVATIONS ----
  def preload
    today = Date.today
    reservations = @bouncehouse.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)
    unavailable_dates = @bouncehouse.calendars.where("status = ? AND day > ?", 1, today)

    special_dates = @bouncehouse.calendars.where("status = ? AND day > ? AND price <> ?", 0, today, @bouncehouse.price)
    
    render json: {
      reservations: reservations,
      unavailable_dates: unavailable_dates,
      special_dates: special_dates
    }
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @bouncehouse)
    }

    render json: output
  end
  
  private
    def is_conflict(start_date, end_date, bouncehouse)
      check = bouncehouse.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
      check_2 = bouncehouse.calendars.where("day BETWEEN ? AND ? AND status = ?", start_date, end_date, 1).limit(1)
      
      check.size > 0 || check_2.size > 0 ? true : false 
    end

    def set_bouncehouse
      @bouncehouse = Bouncehouse.find(params[:id])
    end

    def is_authorized
      redirect_to root_path, alert: "You don't have permission" unless current_user.id == @bouncehouse.user_id
    end

    def is_ready_bouncehouse
      !@bouncehouse.active && !@bouncehouse.price.blank? && !@bouncehouse.listing_name.blank? && !@bouncehouse.photos.blank? && !@bouncehouse.address.blank?
    end

    def bouncehouse_params
      params.require(:bouncehouse).permit(:bouncehouse_type, :time_limit, :pickup_type, :listing_name, :description, :address, :price, :is_heated, :is_slide, :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active, :instant, photos: [])
    end
end