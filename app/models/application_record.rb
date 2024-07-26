class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  include Auditable

  scope :active, -> { where(deleted_at: nil) }
end
