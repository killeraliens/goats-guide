class VenuesController < ApplicationController
  # def create
  #   @venue = Venue.new(venue_params)
  #   if @venue.save
  #     @event = Event.new
  #     @event.venue = @venue
  #     redirect_to new_event_path
  #   else
  #     @event = Event.new
  #     render "events/new", notice: "Venue fields are required"
  #   end
  # end

  # private

  # def venue_params
  #   params.require(:venue).permit(:name, :street, :city, :state, :country, :info)
  # end
end
