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

  def songkick_fetch_event_links
    search_input = 'slayer'
    url = "https://www.songkick.com/search?page=1&per_page=10&query=#{search_input}&type=upcoming"
    html_file = open(url).read
    html = Nokogiri::HTML(html_file)
    events = []
    html.search('.concert').each do |event|
      p "EVENT"
      datetime = event.search('time')
      datetime[0].text
      p datetime = datetime[0]['datetime']
      p title = event.search('.summary a strong').text
      #event.search('strong').remove
      p description = event.css('.summary a').text
      location = event.css('.location').text.gsub("\n", '').strip
      location = location.split(/\s*,\s*/)
      p venue = location[0]
      p city = location[1]
      p state = location[2]
      p country = location[3]
      root = "https://www.songkick.com"
      href = event.search('.summary a')
      href = href[0]['href']
      p event_url = root + href
      events << [datetime, title, description, venue, city, state, country, event_url]
    end
    events
  end

  def songkick_fetch_venue_details
    songkick_fetch_event_links.each do
    html_file = open(url).read
    html = Nokogiri::HTML(html_file)
  end
end
