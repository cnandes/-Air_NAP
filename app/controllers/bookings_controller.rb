class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show confirm decline cancel user_is_host?]
  before_action :cancel_check, only: %i[index show]

  def index
    # removed reject filter from @bookings as it will interfere w/ soon to be auto cancelled bookings (takes 10mins)
    # ie. won't display bookings which have started while those booking's 'confirmation_status' is 'requested'
    @bookings = current_user.bookings.order(:start_time)#.reject(&:started?)
    @bookings_to_approve = current_user.nap_spaces.map(&:bookings).flatten.reject(&:started?)
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

  # TODO: ask an adult if this (cancel_check method) should be a class method? (Booking.cancel_check) or don't 😎
  # Auto cancels all bookings which have not been accepteed/declined if 10 mins has passed since their start_time
  def cancel_check
    Booking.all.select(&:requested?).each do |booking|
      if Time.parse(DateTime.now.to_s).utc >= Time.parse(booking.start_time.to_s).utc + 600
        booking.confirmation_status = 'cancelled'
        booking.save!
      end
    end
  end
end
