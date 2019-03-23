class EventsController < ApplicationController
  before_action :find_event, only: %i[show update saved_event_create]
  skip_before_action :authenticate_user!, only: %i[index index_past show]

  def index
    if params[:query].present?
      @events = Event.joins(:venue).where(sql_query, query: "%#{params[:query]}%").upcoming_events
    else
      @events = Event.order(date: 'ASC').upcoming_events
    end
  end

  def index_past
    if params[:query].present?
      @events = Event.joins(:venue).where(sql_query, query: "%#{params[:query]}%").past_events
    else
      @events = Event.order(date: 'ASC').past_events
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.event_creator = current_user
    @venue = Venue.new(venue_params)
    render :new, notice: "Name, city, and country fields are required" if !@venue.save
    if @event.save
      redirect_to event_path(@event), notice: 'event created'
    else
      render :new, notice: "Missing required fields"
    end
  end

  def update
    @event.title = params[:event][:title]
    @event.description = params[:event][:description]
    @event.date = params[:event][:date]
    @event.end_date = params[:event][:end_date]
    @event.photo = params[:event][:photo]
    if @event.save
      redirect_to event_path(@event), notice: 'Updated'
    else
      render :show, notice: "Couldn't save"
    end
  end

  private

  def sql_query
    " \
        events.title ILIKE :query \
        OR events.description ILIKE :query \
        OR venues.name ILIKE :query \
        OR venues.info ILIKE :query \
      "
  end

  def find_event
    @event = Event.find(params[:id])
  end

  # def find_event_creator
  #   if params[:event_creator_type] == "User"
  #     @event.event_creator = User.find(params[:user_id])
  #   else
  #     @event.event_creator = ScrapeJob.find(params[:scrape_job_id])
  #   end
  # end

  def event_params
    params.require(:event).permit(:title, :description, :date, :end_date, :time, :venue, :photo)
  end

  def venue_params
    params.require(:venue).permit(:name, :country, :state, :city, :street_address, :info)
  end
end
