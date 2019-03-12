require 'nokogiri'
require 'open-uri'
require 'mechanize'


def songkick_fetch_index
  html_dir = File.join(__dir__, 'songkick.html')
  # file = open(html_dir).read
  # doc = Nokogiri::HTML(file)
  # p doc
  agent = Mechanize.new
  page = agent.get("file:///#{html_dir}")
  events = []
    page.search('.concert').each do |event|
       "EVENT"
      datetime = event.search('time')
      datetime[0].text
       datetime = datetime[0]['datetime']
       title = event.search('.summary a strong').text
      #event.search('strong').remove
       description = event.css('.summary a').text
      location = event.css('.location').text.gsub("\n", '').strip
      location = location.split(/\s*,\s*/)
       venue = location[0]
       city = location[1]
       state = location[2]
       country = location[3]
      root = "https://www.songkick.com"
      href = event.search('.summary a')
      href = href[0]['href']
      event_url = root + href
      events << [datetime, title, description, venue, city, state, country, event_url]
    end
    events

end
#songkick_fetch_index


 def songkick_fetch_event
   html_dir = File.join(__dir__, 'songkick_show.html')
   agent = Mechanize.new
   page = agent.get("file:///#{html_dir}")
   page.search('.biography-container').text.gsub("\n", '').strip
   title = page.css('h1 a').text
   venue_name = page.search('.venue-info-details a').first.text.gsub("\n", '').strip
   address = page.search('.venue-hcard').text.gsub("\n", ' ').squeeze(' ').strip
   lineup = page.search('.line-up').text.gsub("\n", ' ').squeeze(' ').strip
   p event_details = [title, venue_name, address, lineup]
   songkick_fetch_index.each do |event|
     puts event
     puts "----------------"
   end
 end
 songkick_fetch_event
