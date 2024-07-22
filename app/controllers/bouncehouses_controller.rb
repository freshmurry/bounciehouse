class BouncehousesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_bouncehouse, only: [:show, :edit, :update, :destroy, :preload, :preview]
  before_action :is_authorized, only: [:listing, :pricing, :description, :photo_upload, :amenities, :address, :update]

  def index
    @bouncehouses = current_user.bouncehouses
  end

  def new
    @bouncehouse = current_user.bouncehouses.build(active: true) # Default to active
  end

  def create
    @bouncehouse = current_user.bouncehouses.build(bouncehouse_params)
    if @bouncehouse.save
      if params[:bouncehouse][:photos]
        params[:bouncehouse][:photos].each do |photo|
          @bouncehouse.photos.attach(photo)
        end
      end
      redirect_to @bouncehouse, notice: "Bounce house listing was successfully created."
    else
      flash[:alert] = "Something went wrong. Please check the form and try again."
      render :new
    end
  end

  def show
    @bouncehouse = Bouncehouse.find(params[:id])
    return redirect_to root_path, alert: "Bounce house not found" unless @bouncehouse

    @photos = @bouncehouse.photos
    # Ensure 'review_type' is the correct column or adjust accordingly
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

  def amenities
  end

  def location
  end

  def edit
    if current_user.id == @bouncehouse.user.id
      @photos = @bouncehouse.photos
    else
      redirect_to root_path, notice: "You don't have permission."
    end
  end

  def update
    if @bouncehouse.update(bouncehouse_params)
      if params[:bouncehouse][:photos]
        params[:bouncehouse][:photos].each do |photo|
          @bouncehouse.photos.attach(photo)
        end
      end
      redirect_to @bouncehouse, notice: "Bounce house listing was successfully updated."
    else
      flash[:alert] = "Something went wrong. Please check the form and try again."
      render :edit
    end
  end

  def destroy
    @bouncehouse.destroy
    redirect_to bouncehouses_url, notice: "Bounce house listing was successfully destroyed."
  end

  private

  def set_bouncehouse
    @bouncehouse = Bouncehouse.find(params[:id])
  end

  def is_authorized
    redirect_to root_path, alert: "You don't have permission." unless current_user.id == @bouncehouse.user.id
  end

  def bouncehouse_params
    params.require(:bouncehouse).permit(:bouncehouse_type, :time_limit, :pickup_type, :instant, :listing_name, :description, :address, :price, :is_heated, :is_slide, :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active, photos: [])
  end
end
