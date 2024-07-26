class HostReview < Review
  belongs_to :host, class_name: "User"

  # Validate that a host is associated with the review
  validates :host_id, presence: true
end
