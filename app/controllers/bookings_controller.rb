class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show confirm decline cancel user_is_host?]

  def index
    @bookings = current_user.bookings.order(:start_time).reject(&:started?)
    @bookings_to_approve = current_user.nap_spaces.map(&:bookings).flatten.reject(&:started?).reject(&:cancelled?)
    @bookings_past = current_user.bookings.select(&:ended?).select(&:confirmed?)
    @review = Review.new
  end

  def new
    @nap_space = NapSpace.find(params[:nap_space_id])
    @booking = Booking.new
  end

  def create
    @user = current_user
    @nap_space = NapSpace.find(params[:nap_space_id])
    @booking = Booking.new(strong_params)
    @booking.nap_space = @nap_space
    @booking.user = @user
    @booking.confirmation_status = 'requested'
    if @booking.save
      redirect_to bookings_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def confirm
    return unless user_is_host?
    return if @booking.cancelled? || @booking.started?

    @booking.confirmation_status = 'confirmed'
    redirect_to bookings_path if @booking.save!
  end

  def decline
    return unless user_is_host?
    return if @booking.cancelled? || @booking.started?

    @booking.confirmation_status = 'declined'
    redirect_to bookings_path if @booking.save!
  end

  def cancel
    return unless current_user == @booking.user
    return if @booking.started?

    @booking.confirmation_status = 'cancelled'
    redirect_to bookings_path if @booking.save
  end

  private

  def user_is_host?
    current_user == @booking.nap_space.user
  end

  def strong_params
    params.require(:booking).permit(:start_time, :end_time)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
