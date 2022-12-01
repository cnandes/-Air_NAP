class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :nap_space
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :confirmation_status, inclusion: { in: %w[requested confirmed declined cancelled] }

  def confirm
    change_confirmation_status('confirmed')
  end

  def decline
    change_confirmation_status('declined')
  end

  def cancel
    change_confirmation_status('cancel')
  end

  private

  def change_confirmation_status(status)
    this.confirmation_status = status
  end
end
