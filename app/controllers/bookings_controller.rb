class BookingsController < ApplicationController
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
