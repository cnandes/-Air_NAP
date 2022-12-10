class NapSpacesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :set_nap_space, only: %i[show edit update destroy]
  before_action :set_user, only: %i[show create index_by_user]
  def home
  end

  def index
    if params[:query].present?
      sql_query = <<~SQL
        nap_spaces.address @@ :query
        OR nap_spaces.description @@ :query
      SQL
      @nap_spaces = NapSpace.where(sql_query, query: "%#{params[:query]}%")
    else
      @nap_spaces = NapSpace.all
    end

    @markers = @nap_spaces.geocoded.map do |nap_space|
      marker_info(nap_space)
    end
  end

  def index_by_user
    @nap_spaces = NapSpace.where(@user == :user)
  end

  def show
    @booking = Booking.new
    @bookings = @nap_space.bookings
    @reviews = @bookings.map(&:review)
    @marker = []
    return unless @nap_space.geocoded?

    @marker = [marker_info(@nap_space)]
  end

  def new
    @nap_space = NapSpace.new
  end

  def create
    @nap_space = NapSpace.new(nap_space_params)
    @nap_space.user = @user

    if @nap_space.save
      redirect_to nap_space_path(@nap_space)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @nap_space.update(nap_space_params)
      redirect_to @nap_space, notice: "NapSpace was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @nap_space.destroy
      redirect_to root_path, status: :see_other
    else
      render @nap_space, status: :unprocessable_entity
    end
  end

  private

  def set_nap_space
    @nap_space = NapSpace.find(params[:id])
  end

  def nap_space_params
    params.require(:nap_space).permit(:description, :address, :cost_per_hr, :image_url)
  end

  def set_user
    @user = current_user
  end

  def marker_info(nap_space)
    return {
      lat: nap_space.latitude,
      lng: nap_space.longitude,
      info_window: render_to_string(partial: "popup", locals: { nap_space: nap_space }),
      image_url: helpers.asset_url("spent_marker.png")
    }
  end
end
