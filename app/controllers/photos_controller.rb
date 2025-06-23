class PhotosController < ApplicationController
  before_action :set_bouncehouse

  def index
    @photos = @bouncehouse.photos
  end

  def destroy
    photo = @bouncehouse.photos.find(params[:id])
    photo.purge
    redirect_to edit_bouncehouse_path(@bouncehouse), notice: "Photo deleted."
  end

  def show
    @bouncehouse = Bouncehouse.find(params[:id])
  end

  private

  def set_bouncehouse
    @bouncehouse = Bouncehouse.find(params[:bouncehouse_id])
  end
end
