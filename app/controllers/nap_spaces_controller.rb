class NapSpacesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
  end

  def index
    @nap_spaces = NapSpace.all
  end

  def show
    # @nap_space = NapSpace.find(params[:id])
  end

  def new
    @nap_space = NapSpace.new
  end

  def create
    @user = current_user # TODO: replace w private set_user method
    @nap_space = NapSpace.new(nap_space_params)
    @nap_space.user = @user

    if @nap_space.save
      redirect_to nap_space_path(@nap_space)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def nap_space_params
    params.require(:nap_space).permit(:description, :address, :cost_per_hr, :image_url)
  end
end
