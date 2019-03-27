class VenuesController < ApplicationController

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      redirect_to new_event_path
    else
      @event = Event.new
      render "events/new"
    end
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :city, :state, :country)
  end
end
