class SavedEventsController < ApplicationController

  def create
    @saved_event = SavedEvent.new
    @saved_event.user = current_user
    @saved_event.event = Event.find(params[:event_id])
    if @saved_event.save
      redirect_to root_path
    else
      puts "somethings up, event not saved"
    end
  end

  def update
    # @event = Event.find(params[:id])
    # savex = current_user ? SavedEvent.where(event_id: @event.id, user_id: current_user.id) : nil
    # @saved_event = savex ? savex : SavedEvent.new
  end
end

