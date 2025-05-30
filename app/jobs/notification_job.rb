class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    notification.user.increment!(:unread)
    ActionCable.server.broadcast "notification_#{notification.user.id}", message: render_notification(notification), unread: notification.user.unread
    # ActionCable.server.broadcast "notifications:#{notification.recipient_id}", html: html
  end

  private

    def render_notification(notification)
      ApplicationController.render(partial: 'notifications/notification', locals: { notification: notification})
    end
end