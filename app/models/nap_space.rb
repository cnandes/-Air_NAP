class NapSpace < ApplicationRecord
  has_many :bookings
  belongs_to :user

  has_many :reviews, through: :bookings

  validates :address, presence: true
  validates :address, uniqueness: true
  validates :cost_per_hr, presence: true
  validates :cost_per_hr, numericality: {greater_than_or_equal_to: 0}
end
