class PhotosController < ApplicationController
  before_action :set_bouncehouse, only: [:destroy]
  before_action :set_photo, only: [:destroy]

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end  

  private

  def set_bouncehouse
    @bouncehouse = Bouncehouse.find(params[:bouncehouse_id])
  end

  def set_photo
    @photo = @bouncehouse.photos.find(params[:id])
  end
end
