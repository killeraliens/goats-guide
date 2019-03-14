class BandsController < ApplicationController

  def create
    @band = Band.new(band_params)
    @band.save
  end

  # def destroy
  #   @band = Band.find(params[:id])
  #   @band.destroy
  # end

  private

  def band_params
    params.require(:band).permit(:name)
  end
end
