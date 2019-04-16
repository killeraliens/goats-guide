class EventsController < ApplicationController
  before_action :find_event, only: %i[show update edit destroy]
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

    @markers = @events.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude
      }
    end
    # if !current_user.nil?
    #   saved_event_ids = current_user.saved_events.map {|event| event.event_id }
    #   @saved_events = Event.find(saved_event_ids)
    # end
  end

  def index_past
    if params[:query].present?
      @events = Event.global_search(params[:query]).past_events
    else
      @events = Event.order(date: 'ASC').past_events
    end
    # if !current_user.nil?
    #   saved_event_ids = current_user.saved_events.map {|event| event.event_id }
    #   @saved_events = Event.find(saved_event_ids)
    # end
  end

  def new
    @venue = Venue.new
    @event = Event.new
  end

  def create
    @venue = Venue.new(venue_params)
    @event = Event.new(event_params)
    @event.creator = current_user
    date_validate
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
    date_validate
    if params[:venue][:name].present?
      @venue = Venue.new(venue_params)
      if @venue.save
        @event.venue = @venue
        @event.update(event_params)
      elsif Venue.exists?(name: params[:venue][:name], city: params[:venue][:city])
        @event.venue = Venue.find_by(name: params[:venue][:name], city: params[:venue][:city])
      else
        @event.venue
      end
    end
    if @event.save
      redirect_to event_path(@event), notice: 'Updated'
    else
      render :show, notice: "Couldn't save"
    end
  end

  def edit
    @venue = Venue.new
  end

  def destroy
    if @event.destroy
      redirect_to request.referrer, notice: "Removed #{@event.title}"
    else
      redirect_to request.referrer, notice: "Could not delete #{@event.title}"
    end
  end

  private

  def find_event
    @event = Event.find(params[:id])
  end

  def date_validate
    if @event.date.nil? || (@event.date.instance_of?(Date) && @event.date < Date.today)
      @event.date = Date.today
    end
    if @event.end_date.nil? || (@event.end_date.instance_of?(Date) && @event.end_date < @event.date)
      @event.end_date = @event.date
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :end_date, :time, :photo, :source)
  end

  def venue_params
    params.require(:venue).permit(:name, :country, :state, :city, :street, :info)
  end
end
