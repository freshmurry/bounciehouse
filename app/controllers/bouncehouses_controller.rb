class BouncehousesController < ApplicationController
  before_action :set_bouncehouse, only: [:update, :edit, :destroy, :show, :preload_reservations, :preview_reservations]
  before_action :authorized_user!, only: [:edit, :update, :destroy]
  
  def index
    @bouncehouses = current_user.bouncehouses
  end

  def show
    @bouncehouse = Bouncehouse.find(params[:id])
    @photos = @bouncehouse.photos
    @guest_reviews = Review.where(type: "GuestReview")
  end

  def new
    @bouncehouse = current_user.bouncehouses.build
  end

  def create
    @bouncehouse = Bouncehouse.new(bouncehouse_params.except(:photos))
    if params[:bouncehouse][:photos]
      ordered_files = order_files(params[:bouncehouse][:photos], params[:photo_order])
      ordered_files.each { |file| @bouncehouse.photos.attach(file) }
    end
    if @bouncehouse.save
      redirect_to @bouncehouse, notice: "Bouncehouse created!"
    else
      render :new
    end
  end

  def edit
    @photos = @bouncehouse.photos
  end

  def update
    @bouncehouse = Bouncehouse.find(params[:id])
    if params[:bouncehouse][:photos]
      ordered_files = order_files(params[:bouncehouse][:photos], params[:photo_order])
      ordered_files.each { |file| @bouncehouse.photos.attach(file) }
    end
    if @bouncehouse.update(bouncehouse_params.except(:photos))
      redirect_to @bouncehouse, notice: "Bouncehouse updated!"
    else
      render :edit
    end
  end

  # ----- RESERVATIONS -----
  def preload_reservations
    begin
      @reservations = @bouncehouse.reservations.where("start_date <= ? AND end_date >= ?", Date.today, Date.today)

      respond_to do |format|
        format.json { render json: { reservations: @reservations } }
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def preview_reservations
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

  def destroy
    @bouncehouse.destroy
    redirect_to bouncehouses_url, notice: 'Bouncehouse deleted successfully.'
  end

  private

  def set_bouncehouse
    @bouncehouse = Bouncehouse.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Bouncehouse not found."
    redirect_to root_path
  end

  def authorized_user!
    redirect_to root_path, alert: "You don't have permission" unless current_user.id == @bouncehouse.user_id
  end

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
