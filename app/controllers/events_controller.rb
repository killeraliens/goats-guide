
class EventsController < ApplicationController
  before_action :find_event, only: [:show, :update, :saved_event_create]
  skip_before_action :authenticate_user!, only: [:index, :show]
  # has_scope :query

  def index
    # @events = Event.order(date: 'ASC').upcoming_events
    # @events = Event.order(date: 'ASC').upcoming_events if params["events"].present?
    # @events = Event.order(date: 'ASC').past_events if params["past"].present?
    if params[:query].present?
      sql_query = " \
        events.title ILIKE :query \
        OR events.description ILIKE :query \
        OR venues.name ILIKE :query \
        OR venues.info ILIKE :query \
      "
    end
    if params[:query].present? && params["events"].present?
      @events = Event.joins(:venue).where(sql_query, query: "%#{params[:query]}%").upcoming_events
    elsif params[:query].present? && params["past"].present?
      @events = Event.joins(:venue).where(sql_query, query: "%#{params[:query]}%").past_events
    elsif params["events"].present?
      @events = Event.order(date: 'ASC').upcoming_events
    elsif params["past"].present?
      @events = Event.order(date: 'ASC').past_events
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.create(event_params)
    @event.user = current_user
    if @event.save
      redirect_to events_path, notice: 'event created'
    else
      render :new
    end
  end

  def update
  end

  private

  def find_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :end_date, :time, :venue)
  end
end
