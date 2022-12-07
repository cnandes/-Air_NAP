class Review < ApplicationRecord
  belongs_to :booking
  validates :content, presence: true
  validates :rating, presence: true, numericality: {
    in: (1..5)
  }
end
