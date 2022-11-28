class NapSpacesController < ApplicationController
  def home
  end

  def index
    @nap_spaces = NapSpace.all
  end
end
