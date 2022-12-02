class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :nap_space
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :user, presence: true
  validates :nap_space, presence: true
  validates :confirmation_status, presence: true, inclusion: { in: %w[requested confirmed declined cancelled] }
end
