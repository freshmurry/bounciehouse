class PhotosController < ApplicationController
  before_action :set_bouncehouse

  def create
    @photo = @bouncehouse.photos.build(photo_params)

    if @photo.save
      redirect_to @bouncehouse, notice: "Photo added successfully!"
    else
      logger.error "Failed to save photo: #{@photo.errors.full_messages}"
      render :new
    end
  end

  def destroy
    photo = @bouncehouse.photos.find(params[:id])
    logger.debug "Destroying photo: #{photo.id}"
    photo.images.each do |image|
      logger.debug "Purging image: #{image.filename}"
      image.purge
    end
    photo.destroy
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
