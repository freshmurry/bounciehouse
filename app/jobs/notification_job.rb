class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    # Increment the unread count for the user
    notification.user.increment!(:unread)

    # Broadcast the notification to the user's specific channel
    ActionCable.server.broadcast "notification_#{notification.user.id}", 
                                 message: render_notification(notification), 
                                 unread: notification.user.unread
  end

  private

  # Render the notification partial to be sent over ActionCable
  def render_notification(notification)
    ApplicationController.renderer.render(
      partial: 'notifications/notification',
      locals: { notification: notification }
    )
  end
end
