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
end
