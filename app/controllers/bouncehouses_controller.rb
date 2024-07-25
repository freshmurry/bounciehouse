# class BouncehousesController < ApplicationController
#   before_action :authenticate_user!, except: [:index, :show]
#   before_action :set_bouncehouse, only: [:show, :edit, :update, :destroy, :preload, :preview]
#   before_action :is_authorized, only: [:listing, :pricing, :description, :photo_upload, :amenities, :address, :update]

#   def index
#     @bouncehouses = current_user.bouncehouses
#   end

#   def show
#     @bouncehouse = Bouncehouse.find(params[:id])
#     return redirect_to root_path, alert: "Bounce house not found" unless @bouncehouse

#     @photos = @bouncehouse.photos
#     # Ensure 'review_type' is the correct column or adjust accordingly
#     @guest_reviews = Review.where(type: "GuestReview")
#   end

#   def new
#     @bouncehouse = current_user.bouncehouses.build(active: true) # Default to active
#   end

#   def create
#     @bouncehouse = current_user.bouncehouses.build(bouncehouse_params)
#     if @bouncehouse.save
#       if params[:bouncehouse][:photos]
#         params[:bouncehouse][:photos].each do |photo|
#           @bouncehouse.photos.attach(photo)
#         end
#       end
#       redirect_to @bouncehouse, notice: "Bounce house listing was successfully created."
#     else
#       flash[:alert] = "Something went wrong. Please check the form and try again."
#       render :new
#     end
#   end

#   def listing
#   end

#   def pricing
#   end

#   def description
#   end

#   def photo_upload
#     @photos = @bouncehouse.photos
#   end

#   def amenities
#   end

#   def edit
#     if current_user.id == @bouncehouse.user.id
#       @photos = @bouncehouse.photos
#     else
#       redirect_to root_path, notice: "You don't have permission."
#     end
#   end

#   def update
#     if @bouncehouse.update(bouncehouse_params)
#       if params[:bouncehouse][:photos]
#         params[:bouncehouse][:photos].each do |photo|
#           @bouncehouse.photos.attach(photo)
#         end
#       end
#       redirect_to @bouncehouse, notice: "Bounce house listing was successfully updated."
#     else
#       flash[:alert] = "Something went wrong. Please check the form and try again."
#       render :edit
#     end
#   end

#   def destroy
#     @bouncehouse.destroy
#     redirect_to bouncehouses_url, notice: "Bounce house listing was successfully destroyed."
#   end

#   private

#   def set_bouncehouse
#     @bouncehouse = Bouncehouse.find(params[:id])
#   end

#   def is_authorized
#     redirect_to root_path, alert: "You don't have permission." unless current_user.id == @bouncehouse.user.id
#   end

#   def bouncehouse_params
#     params.require(:bouncehouse).permit(:bouncehouse_type, :time_limit, :pickup_type, :instant, :listing_name, :description, :address, :price, :is_heated, :is_slide, :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active, photos: [])
#   end
# end

class BouncehousesController < ApplicationController
  before_action :set_bouncehouse, only: [:show, :edit, :update, :preload]

  def index
    @bouncehouses = current_user.bouncehouses
  end

  # def show
  #   @photos = @bouncehouse.photos
  #   @booked = Reservation.where("bouncehouse_id = ? AND user_id = ?", @bouncehouse.id, current_user.id).present? if current_user
  #   @guest_reviews = Review.where(type: "GuestReview")
  # end

  def show
    # @bouncehouse = Bouncehouse.find(params[:id])
    @photos = @bouncehouse.photos
    @guest_reviews = Review.where(type: "GuestReview")
  end

  def new
    @bouncehouse = current_user.bouncehouses.build
  end

  def create
    @bouncehouse = current_user.bouncehouses.build(bouncehouse_params)
  
    if @bouncehouse.save
      if params[:images].present?
        params[:images].each do |image|
          @bouncehouse.photos.create(image: image)
          # @bouncehouse.photos.attach(image)
        end
      end
      @photos = @bouncehouse.photos
      redirect_to bouncehouse_path(@bouncehouse), notice: "Saved..."
    else
      render :new
    end
  end
  
  def edit
    if current_user.id == @bouncehouse.user.id
      @photos = @bouncehouse.photos
    else
      redirect_to root_path, notice: "You don't have permission."
    end
  end

  def update
    new_params = bouncehouse_params
    # new_params = bouncehouse_params.merge(active: true) if is_ready_bouncehouse

    if @bouncehouse.update(new_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_to bouncehouse_path(@bouncehouse), notice: "Saved..."
  end
  
  def destroy
    @bouncehouse = Bouncehouse.find(params[:id])
    @bouncehouse.destroy

    redirect_to root_path, notice: "Deleted..."
  end
  
  #---- RESERVATIONS ----
  def preload
    today = Date.today
    reservations = @room.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)
    unavailable_dates = @room.calendars.where("status = ? AND day > ?", 1, today)

    special_dates = @room.calendars.where("status = ? AND day > ? AND price <> ?", 0, today, @room.price)
    
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
      conflict: is_conflict(start_date, end_date, @room)
    }

    render json: output
  end
  
  private

    def set_bouncehouse
      @bouncehouse = Bouncehouse.find(params[:id])
    end

    def bouncehouse_params
      params.require(:bouncehouse).permit(:bouncehouse_type, :time_limit, :pickup_type, :instant, :listing_name, :description, :address, :price, :is_heated, :is_slide, :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active)
    end
end
