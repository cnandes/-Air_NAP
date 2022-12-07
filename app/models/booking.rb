class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :nap_space
  has_one :review
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :user, presence: true
  validates :nap_space, presence: true
  validates :confirmation_status, presence: true, inclusion: { in: %w[requested confirmed declined cancelled] }

  validate :end_time_after_start_time

  def total_cost
    duration = (Time.parse(end_time.to_s) - Time.parse(start_time.to_s)) / 3600
    (duration * nap_space.cost_per_hr).round(2)
  end

  def started?
    Time.parse(DateTime.now.to_s) > Time.parse(start_time.to_s)
  end

  def ended?
    Time.parse(DateTime.now.to_s) > Time.parse(end_time.to_s)
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "must be after the start date")
    end
  end
end
