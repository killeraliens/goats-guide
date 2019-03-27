class EventsController < ApplicationController
  before_action :find_event, only: %i[show update saved_event_create]
  skip_before_action :authenticate_user!, only: %i[index index_past show]

  def index
    if params[:query].present?
      # @events = Event.joins(:venue, :creator).where(sql_query, query: "%#{params[:query]}%").upcoming_events
      @events = Event.global_search(params[:query]).upcoming_events
    else
      @events = Event.order(date: 'ASC').upcoming_events
    end
  end

  def index_past
    if params[:query].present?
      # @events = Event.joins(:venue, :creator).where(sql_query, query: "%#{params[:query]}%").past_events
      @events = Event.global_search(params[:query]).past_events
    else
      @events = Event.order(date: 'ASC').past_events
    end
  end

  def new
    @event = Event.new
    @venue = Venue.new
  end

  def create
    @event = Event.new(event_params)
    @event.creator = current_user
    render :new, notice: "Name, city, and country fields are required" if !@venue.save
    if @event.save
      redirect_to event_path(@event), notice: 'event created'
    else
      render :new, notice: "Missing required fields"
    end
  end

  def update
    @event.update(event_params)
    if @event.save
      redirect_to event_path(@event), notice: 'Updated'
    else
      render :show, notice: "Couldn't save"
    end
  end

  private

  # def sql_query
  #   " \
  #       events.title ILIKE :query \
  #       OR events.description ILIKE :query \
  #       OR venues.name ILIKE :query \
  #       OR venues.info ILIKE :query \
  #       OR users.username ILIKE :query \
  #     "
  # end

  def find_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :end_date, :time, :venue, :photo, :creator, :source)
  end

  def venue_params
    params.require(:venue).permit(:name, :country, :state, :city, :street_address, :info)
  end
end
