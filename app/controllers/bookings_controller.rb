class BookingsController < ApplicationController
  before_action :set_booking, only: %i[confirm decline cancel]

  def index
    @bookings = Booking.where(user_id: current_user.id)
  end

  def show
    @nap_space = @booking.nap_space
  end

  def confirm
    @booking.confirm if current_user == @booking.nap_space.user
  end

  def decline
    @booking.decline if current_user == @booking.nap_space.user
  end

  def cancel
    @booking.cancel if current_user == @booking.user
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end
end