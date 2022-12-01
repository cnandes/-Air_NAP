class BookingsController < ApplicationController

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

  private

  def strong_params
    params.require(:booking).permit(:start_time, :end_time)
  end
end
