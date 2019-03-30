class SavedEventsController < ApplicationController
  def create
    @saved_event = SavedEvent.new
    @saved_event.user = current_user
    @saved_event.event = Event.find(params[:event_id])
    if @saved_event.save
      redirect_to event_path(@saved_event.event), notice: 'Event saved.'
    else
      redirect_to event_path(@saved_event.event), notice: "UH OH. Couldn't save."
    end
  end

  def destroy
    saved_event = SavedEvent.find(params[:id])
    if saved_event.destroy
      # respond_to do |format|
      #   format.js { render inline: "location.reload();" }
      # end
      redirect_to request.referrer, notice: "Removed #{saved_event.event.title}"
    else
      redirect_to request.referrer, notice: "Could not delete #{saved_event.event.title}"
    end
  end
end
