class NapSpace < ApplicationRecord
  has_many :bookings, dependent: :destroy
  belongs_to :user

  has_many :reviews, through: :bookings

  has_one_attached :image_url

  validates :address, presence: true
  validates :address, uniqueness: true
  validates :cost_per_hr, presence: true
  validates :cost_per_hr, numericality: { greater_than_or_equal_to: 0 }

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
