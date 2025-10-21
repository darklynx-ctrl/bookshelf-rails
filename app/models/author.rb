class Author < ApplicationRecord
  has_many :books, dependent: :restrict_with_error
  
  scope :active, -> { where(active: true) }
  
  validates :name, presence: { message: "повинно бути заповнене" }
  validates :bio, presence: { message: "повинна бути заповнена" }
end
