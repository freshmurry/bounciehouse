class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:show,:destroy]

  def index
    current_user.unread = 0
    current_user.save
    @notifications = current_user.notifications.reverse
  end

  def destroy
    @notification.destroy
    format.js

    redirect_back(fallback_location: request.referer, notice: "Notification Deleted!")
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notifications.find(params[:id])
    end
  	
end