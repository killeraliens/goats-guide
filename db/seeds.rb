require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'pry-byebug'

puts "seeding .."
Venue.destroy_all

# 5.times do
#   venue = Venue.create(name: Faker::Games::HalfLife.location, address: Faker::Address.full_address)
#   3.times do
#     Event.create(title: Faker::Music::RockBand.name, description: Faker::Movies::VForVendetta.speech, date: Faker::Date.forward(23), time: Faker::Superhero.descriptor, venue: venue)
#   end
# end

  def songkick_fetch_index(band_name)
    band_name = "obituary"
    url = "https://www.songkick.com/search?page=1&per_page=30&query=#{band_name}&type=upcoming"

    agent = Mechanize.new
    page = agent.get(url)
    # html_file = open(url).read
    # page = Nokogiri::HTML(html_file)

    another_page = true
    page_num = 1

    while another_page == true

      page.search('.concert').each do |event|
        p "NEW EVENT"
        p page.search('h1').text.gsub("\n", ' ').squeeze(' ').strip
        datetime = event.search('time')
        datetime = datetime[0]['datetime']
        time = DateTime.parse(datetime)
        time = "#{time.hour}:#{time.min}"
        title = event.search('.summary a strong').text
        description = event.css('.summary a').text
        location = event.css('.location').text.gsub("\n", '').strip
        location = location.split(/\s*,\s*/)
        venue_name = location[0]
        root = "https://www.songkick.com"
        href = event.search('.summary a')
        href = href[0]['href']
        event_url = root + href

        page = agent.get(event_url)

        raw_address = page.search('.venue-hcard').text.split("\n")
        raw_address = raw_address.each { |line| line.strip! }
        raw_address = raw_address.select { |item| item != "" }
        street_address = raw_address[0]
        zipcode = raw_address[1]
        city_state_country = raw_address[2].split(',')
        city = city_state_country[0]
        state = city_state_country[1].strip
        country = city_state_country[2].strip


        # p "AFTER AGENTBACK"
        # p page.search('h1').text.gsub("\n", ' ').squeeze(' ').strip

        venue = Venue.new(name: venue_name, street_address: street_address, city: city, state: state, country: country)
        if venue.save
          event = Event.create(date: datetime, time: time, title: title, description: description, venue: venue, url_link: event_url)
          puts "created #{event.date} at #{venue.name}"
          # page = agent.back()
          # return page
        else
          venue = Venue.find_by(name: venue_name, street_address: street_address)
          event = Event.create(date: datetime, time: time, title: title, description: description, venue: venue, url_link: event_url)
          puts "#{venue.name} already created, created this event #{event.date}"
          # page = agent.back()
          # return page
        end
      end
      url = "https://www.songkick.com/search?page=#{page_num}&per_page=30&query=#{band_name}&type=upcoming"
      page = agent.get(url)
      disabled_next_button = page.search('div.pagination span')
      p disabled_next_button.text
      if disabled_next_button.text.include?("Next") == false
        url = "https://www.songkick.com/search?page=#{page_num + 1}&per_page=30&query=#{band_name}&type=upcoming"
        puts "next page buttonn is not disabled" # "Youre on one of the previous pages"
        # html_file = open(url).read
        # page = Nokogiri::HTML(html_file) # "Youre on one of the previous pages"
        page = agent.get(url)
      else
        puts "last page"
        another_page = false # "Youre on the last page"
      end
      page_num += 1
      puts "on to next page"
    end
  end
songkick_fetch_index("obituary")
puts "ending seed.."
