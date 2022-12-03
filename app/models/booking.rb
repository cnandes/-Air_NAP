class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :nap_space
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :user, presence: true
  validates :nap_space, presence: true
  validates :confirmation_status, presence: true, inclusion: { in: %w[requested confirmed declined cancelled] }

  def total_cost
    duration = (Time.parse(end_time.to_s) - Time.parse(start_time.to_s)) / 3600
    (duration * nap_space.cost_per_hr).round(2)
  end
end
