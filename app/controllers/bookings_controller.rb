class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show confirm decline cancel host?]

  def index
    @bookings = Booking.where(user_id: current_user.id)
  end

  def show
  end

  def confirm
    return unless user_is_host?
    return if cancelled?(@booking)

    @booking.confirmation_status = 'confirmed'
    redirect_to booking_path(@booking) if @booking.save!
  end

  def decline
    return unless user_is_host?
    return if cancelled?(@booking)

    @booking.confirmation_status = 'declined'
    redirect_to booking_path(@booking) if @booking.save!
  end

  def cancel
    return unless current_user == @booking.user

    @booking.confirmation_status = 'cancelled'
    redirect_to booking_path(@booking) if @booking.save
  end

  private

  def cancelled?(booking)
    booking.confirmation_status == 'cancelled'
  end

  def user_is_host?
    current_user == @booking.nap_space.user
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
