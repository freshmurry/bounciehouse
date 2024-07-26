class GuestReview < Review
  belongs_to :guest, class_name: "User"

  # Validate that a guest is associated with the review
  validates :guest_id, presence: true
end
