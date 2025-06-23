class PhotosController < ApplicationController
  before_action :set_bouncehouse

  def create
    @photo = @bouncehouse.photos.build(photo_params)

    if @photo.save
      redirect_to @bouncehouse, notice: "Photo added successfully!"
    else
      render :new
    end
  end

  def destroy
    photo = @bouncehouse.photos.find(params[:id])
    photo.images.each(&:purge) # This removes all attached images
    photo.destroy # Optionally destroy the Photo record itself
    redirect_to edit_bouncehouse_path(@bouncehouse), notice: "Photo deleted."
  end

  private

  def set_bouncehouse
    @bouncehouse = Bouncehouse.find(params[:bouncehouse_id])
  end

  def photo_params
    params.require(:photo).permit(images: [])
  end
end
