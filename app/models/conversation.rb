class Conversation < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: "User"
  belongs_to :recipient, foreign_key: :recipient_id, class_name: "User"
  
  has_many :messages, dependent: :destroy

  # Ensure that a conversation between two users is unique regardless of order
  validates :sender_id, uniqueness: { scope: :recipient_id }
  validates :recipient_id, uniqueness: { scope: :sender_id }

  # Scopes
  scope :involving, -> (user) {
    where("sender_id = ? OR recipient_id = ?", user.id, user.id)
  }
  
  scope :between, -> (user_A, user_B) {
    where("(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)", user_A.id, user_B.id, user_B.id, user_A.id)
  }

  # Ensure database indexes for faster querying
  def self.indexes
    add_index :conversations, [:sender_id, :recipient_id], unique: true
  end
end
