class UrlLinksController < ApplicationController
  def create
  end

  def destroy
    url_link = UrlLink.find(params[:id])
    if url_link.destroy
      redirect_to request.referrer, notice: "Removed #{url_link.url}"
    else
      redirect_to request.referrer, notice: "Could not delete #{url_link.url}"
    end
  end
end
