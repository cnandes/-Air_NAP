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
    duration = duration_hours
    (duration * nap_space.cost_per_hr).round(2)
  end

  def duration_hours
    (Time.parse(end_time.to_s) - Time.parse(start_time.to_s)) / 3600
  end

  def duration_mins
    duration_hours * 60
  end

  def confirmed?
    confirmation_status == "confirmed"
  end

  def cancelled
    confirmation_status == 'cancelled'
  end

  def started?
    DateTime.now > start_time
  end

  def ended?
    DateTime.now > end_time
  end

  def start_time_formatted
    start_time.strftime("%I:%M%p, %m/%d/%Y")
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "must be after the start date")
    end
  end
end
