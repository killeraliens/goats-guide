require 'nokogiri'
require 'open-uri'
require 'mechanize'
require "pry-byebug"
# require 'fakeweb'


def songkick_fetch_index(band_name)
  url = "https://www.songkick.com/search?page=1&per_page=30&query=#{band_name}&type=upcoming"

  # agent = Mechanize.new
  # page = agent.get(url)

  html_file = open(url).read
  page = Nokogiri::HTML(html_file)
  events = []

  another_page = true
  page_num = 1

  while another_page == true

    page.search('.concert').each do |event|

      datetime = event.search('time')
      datetime[0].text
      datetime = datetime[0]['datetime']
      title = event.search('.summary a strong').text
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
      # page = agent.get(event_url)
      # address = page.search('.venue-hcard').text.gsub("\n", ' ').squeeze(' ').strip
      # venue = Venue.create(name: venue, address: city+state+country)
      # events << Event.create(date: datetime, time: datetime, title: title, description: description, venue: venue)
      events << [datetime, title, description, venue, city, state, country, event_url]
    end
    events.each do |event|
      puts event
      puts "----------------"
    end

    disabled_next_button = page.search('.next_page.disabled')
    if disabled_next_button.text == ""
      url = "https://www.songkick.com/search?page=#{page_num + 1}&per_page=30&query=#{band_name}&type=upcoming" # "Youre on one of the previous pages"
      html_file = open(url).read
      page = Nokogiri::HTML(html_file)
    else
      another_page = false # "Youre on the last page"
    end
    page_num += 1
  end

end
songkick_fetch_index("obituary")


# def songkick_fetch_event
#   html_dir = File.join(__dir__, 'songkick_show.html')
#   agent = Mechanize.new
#   page = agent.get("file:///#{html_dir}")
#   band_descripts = page.search('.biography-container').text.gsub("\n", '').strip
#   address = page.search('.venue-hcard').text.gsub("\n", ' ').squeeze(' ').strip

#   p event_details = [band_descripts, address]
#   songkick_fetch_index.each do |event|
#     puts event
#     puts "----------------"
#   end
# end
# songkick_fetch_event

