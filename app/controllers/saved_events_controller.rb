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

end

