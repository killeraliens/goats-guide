class BandsController < ApplicationController

  def create
    @band = Band.new(band_params)
    @band.save
  end

  private

  def band_params
    params.require(:band).permit(:name)
  end
end
