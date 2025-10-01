class Book < ApplicationRecord
  validates :title, presence: { message: "повинна бути вказана" }
  validates :author, presence: { message: "повинен бути вказаний" }
  validates :year, 
    presence: { message: "повинен бути вказаний" },
    numericality: { 
      only_integer: true, 
      greater_than_or_equal_to: 1900, 
      less_than_or_equal_to: 2030,
      message: "повинен бути числом від 1900 до 2030"
    }
end
