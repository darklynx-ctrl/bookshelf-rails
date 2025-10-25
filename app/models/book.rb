class Book < ApplicationRecord
  include CoverUploader::Attachment(:cover) # Додаємо Shrine
  
  belongs_to :author, optional: true
  
  validates :title, presence: { message: "повинна бути заповнена" }
  validates :year, numericality: { 
    only_integer: true, 
    greater_than_or_equal_to: 1500,
    less_than_or_equal_to: 2030,
    message: "має бути числом від 1500 до 2030"
  }, allow_nil: true
  
  scope :search_by_title, ->(query) { where("title ILIKE ?", "%#{query}%") if query.present? }
  scope :sorted_by, ->(column) { order(column) if column.present? }
end

