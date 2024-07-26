class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :context, :conversation_id, :user_id, presence: true
  after_create_commit :create_notification

  def message_time
    self.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  private

  def create_notification
    # Fetch the sender and recipient once
    sender_id = self.conversation.sender_id
    recipient_id = self.conversation.recipient_id
    sender = User.find(sender_id)
    recipient = User.find(recipient_id)
    
    if self.user_id == sender_id
      # Sender has sent the message
      Notification.create(content: "New message from #{sender.fullname}", user_id: recipient_id)
    else
      # Recipient has sent the message
      Notification.create(content: "New message from #{sender.fullname}", user_id: sender_id)
    end
  end
end
