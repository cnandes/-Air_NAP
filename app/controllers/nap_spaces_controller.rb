class NapSpacesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :set_nap_space, only: %i[show edit update destroy]
  before_action :set_user, only: %i[show create]
  def home
  end

  def index
    @nap_spaces = NapSpace.all
  end

  def show
    # @user = current_user
    @booking = Booking.new
  end

  def new
    @nap_space = NapSpace.new
  end

  def create
    # @user = current_user
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
    @nap_space.destroy
    redirect_to root_path, status: :see_other
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
end
