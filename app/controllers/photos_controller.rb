class PhotosController < ApplicationController
  before_action :set_bouncehouse

  def create
    @bouncehouse = Bouncehouse.find(params[:bouncehouse_id])

    if params[:images]
        params[:images].each do |img|
        @bouncehouse.photos.create(image: img)
      end

      @photos = @bouncehouse.photos
      redirect_back(fallback_location: request.referer, notice: "Saved...")
    end
  end

  def destroy
    photo = @bouncehouse.photos.find(params[:id])
    photo.images.each(&:purge) # This removes all attached images
    photo.destroy # Optionally destroy the Photo record itself
    redirect_to edit_bouncehouse_path(@bouncehouse), notice: "Photo deleted."
  end

  # def show
  #   @bouncehouse = Bouncehouse.find(params[:id])
  # end

  private

  def set_bouncehouse
    @bouncehouse = Bouncehouse.find(params[:bouncehouse_id])
  end
end
