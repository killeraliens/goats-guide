require 'nokogiri'
require 'open-uri'

class EventsController < ApplicationController
  before_action :find_event, only: [:show, :update, :saved_event_create]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @events = Event.all
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
    params.require(:event).permit(:title, :description, :date, :time, :venue)
  end

end
