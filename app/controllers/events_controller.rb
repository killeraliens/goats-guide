class EventsController < ApplicationController
  before_action :find_event, only: %i[show update saved_event_create]
  skip_before_action :authenticate_user!, only: %i[index index_past show]

  def index
    params[:date].present? ? startdate = params[:date] : startdate = Date.today
    params[:end_date].present? ? enddate = params[:end_date] : enddate = (Date.today + 100.year)
    query = params[:query] if params[:query].present?

    if params[:query].present?
      @events = Event.where("date >= ? AND date <= ?", startdate, enddate).order(date: 'ASC')
                     .global_search(query).upcoming_events
    else
      @events = Event.where("date >= ? AND date <= ?", startdate, enddate).order(date: 'ASC').upcoming_events
    end
  end

  def index_past
    if params[:query].present?
      @events = Event.global_search(params[:query]).past_events
    else
      @events = Event.order(date: 'ASC').past_events
    end
  end

  def new
    @venue = Venue.new
    @event = Event.new
  end

  def create
    @venue = Venue.new(venue_params)
    @event = Event.new(event_params)
    @event.creator = current_user
    if @venue.save
      @event.venue = @venue
    else
      @event.venue = Venue.find_by(name: params[:venue][:name], city: params[:venue][:city])
    end
    if @event.save
      redirect_to event_path(@event), notice: 'Event created.'
    else
      render :new, notice: "Missing required fields."
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

  def find_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :end_date, :time, :photo, :source)
  end

  def venue_params
    params.require(:venue).permit(:name, :country, :state, :city, :street, :info)
  end
end
