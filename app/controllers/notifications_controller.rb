class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:show, :destroy]

  def index
    current_user.update(unread: 0) # Better practice for updating attributes
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def destroy
    @notification.destroy
    redirect_back(fallback_location: notifications_path, notice: "Notification Deleted!")
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id]) # Ensure the notification belongs to the current user
  end
end
