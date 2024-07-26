class PhotosController < ApplicationController
  before_action :set_bouncehouse, only: [:create, :destroy]

  def create
    if params[:bouncehouse][:photos].present?
      params[:bouncehouse][:photos].each do |photo_file|
        @bouncehouse.photos.create(photo_params.merge(image: photo_file)) # Use strong parameters
      end
      redirect_to @bouncehouse, notice: 'Photos were successfully uploaded.'
    else
      redirect_to @bouncehouse, alert: 'No photos uploaded.'
    end
  end

  def destroy
    @photo = @bouncehouse.photos.find(params[:id])
    if @photo.destroy
      redirect_to @bouncehouse, notice: 'Photo was successfully deleted.'
    else
      redirect_to @bouncehouse, alert: 'Failed to delete photo.'
    end
  end

  private

  def set_bouncehouse
    @bouncehouse = Bouncehouse.find(params[:bouncehouse_id])
  end

  def photo_params
    params.require(:photo).permit(:image) # Use strong parameters for additional security
  end
end
