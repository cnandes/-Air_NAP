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

  def duration_display
    remaining_minutes = (duration_hours - duration_hours.to_i) * 60
    if duration_mins < 60
      "#{duration_mins.to_i} minutes"
    elsif remaining_minutes.to_i.zero?
      "#{duration_hours.to_i} hrs"
    else
      "#{duration_hours.to_i} hrs #{remaining_minutes.to_i} minutes"
    end
  end

  def confirmation_status_styling
    return 'secondary' if ended?
    return 'success' if confirmed?
    return 'primary' if confirmation_status == 'requested'

    return 'danger'
  end

  def confirmed?
    confirmation_status == "confirmed"
  end

  def cancelled?
    confirmation_status == 'cancelled'
  end

  def requested?
    confirmation_status == 'requested'
  end

  def started?
    DateTime.now.new_offset(0) > start_time
  end

  def ended?
    DateTime.now.new_offset(0) > end_time
  end

  def start_time_formatted
    start_time.strftime("%I:%M%p, %m/%d/%Y")
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    return unless end_time < start_time

    errors.add(:end_time, "must be after the start date")
  end
end
