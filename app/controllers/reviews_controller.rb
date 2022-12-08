class ReviewsController < ApplicationController
  before_action :set_booking

  def new
    @review = Review.new
  end

  def create
    return if current_user != @booking.user || @booking.review
    return unless @booking.confirmation_status == "confirmed" && @booking.ended?

    @review = Review.new(review_params)
    @review.booking = @booking
    if @review.save
      redirect_to nap_space_path(@booking.nap_space), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
