require 'nokogiri'
require 'open-uri'
require 'mechanize'

mechanize = Mechanize.new

# require_relative '../../app/models/event'
# require_relative '../../app/models/venue'
# class SongkickScraper
#   def initialize(event_path)
#     @event_path = event_path
#   end

  def songkick_fetch_band_results
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
  #songkick_fetch_band_results

  def songkick_fetch_venue_details
    songkick_fetch_band_results.each do |item|
      url = item[7]
      html_file = open(url).read
      html = Nokogiri::HTML(html_file)
      p venue_name = html.search('.venue-info-details a').first.text.gsub("\n", '').strip
      p address = html.search('.venue-hcard').text.gsub("\n", ' ').squeeze(' ').strip
    end
  end
 songkick_fetch_venue_details
# end
