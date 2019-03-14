require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'chromedriver-helper'
require 'watir'
require 'pry-byebug'

puts "seeding .."
#Venue.destroy_all
#Band.destroy_all

# 5.times do
#   venue = Venue.create(name: Faker::Games::HalfLife.location, address: Faker::Address.full_address)
#   3.times do
#     Event.create(title: Faker::Music::RockBand.name, description: Faker::Movies::VForVendetta.speech, date: Faker::Date.forward(23), time: Faker::Superhero.descriptor, venue: venue)
#   end
# end

  def songkick_fetch_index(band_name)
    #band_name = "obituary"
    url = "https://www.songkick.com/search?page=1&per_page=30&query=#{band_name}&type=upcoming"

    agent = Mechanize.new
    page = agent.get(url)

    pagination_with_link = page.search("div.pagination a" )
    another_page = true
    page_num = 1

    while another_page == true && pagination_with_link.text != ""
      p url
      page.search('.concert').each do |event|
        page.search('h1').text.gsub("\n", ' ').squeeze(' ').strip
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

        venue = Venue.new(name: venue_name, street_address: street_address, city: city, state: state, country: country)
        if venue.save
          event = Event.create(date: datetime, time: time, title: title, description: description, venue: venue, url_link: event_url)
          puts "created #{event.date} at #{venue.name}"
        else
          venue = Venue.find_by(name: venue_name, street_address: street_address)
          event = Event.create(date: datetime, time: time, title: title, description: description, venue: venue, url_link: event_url)
          puts "#{venue.name} already created, created this event #{event.date}"
        end
      end
      url = "https://www.songkick.com/search?page=#{page_num}&per_page=30&query=#{band_name}&type=upcoming"
      page = agent.get(url)
      disabled_next_button = page.search('div.pagination span')
      p disabled_next_button.text
      if disabled_next_button.text.include?("Next") == false
        url = "https://www.songkick.com/search?page=#{page_num + 1}&per_page=30&query=#{band_name}&type=upcoming"
        puts "next page buttonn is not disabled"
        page = agent.get(url)
      else
        puts "last page"
        another_page = false
      end
      page_num += 1
      puts "on to next page"
    end
  end
songkick_fetch_index("ultra silvam")


def metallum_fetch_bands(genre)
  #browser = Watir::Browser.start("https://www.metal-archives.com/search/advanced/searching/bands?bandName=&genre=&country=&yearCreationFrom=&yearCreationTo=&bandNotes=&status=1&themes=&location=&bandLabelName=#bands")
  browser = Watir::Browser.start("https://www.metal-archives.com/search/advanced/searching/bands?bandName=&genre=#{genre}+&country=&yearCreationFrom=&yearCreationTo=&bandNotes=&status=1&themes=&location=&bandLabelName=#bands")
  page = Nokogiri::HTML(browser.html)

  bands = []
    trs = page.search("tbody tr")
    entry_count = page.search("div.dataTables_info").last.text.split(' ')
    current_page = entry_count[3]
    last_page = entry_count[5]

  until current_page == last_page
    page = Nokogiri::HTML(browser.html)
    entry_count = page.search("div.dataTables_info").last.text.split(' ')
    current_page = entry_count[3]
    last_page = entry_count[5]
    trs = page.search("tbody tr")
    trs.each do |tr|
      td = tr.search("td")
      band_arr = td.map { |i| i.text.strip }
      bands << band_arr
    end
    browser.a(class: ["next", "paginate_button"], text: "Next").click
    sleep(2)
  end
  browser.close
  bands.uniq!
  names_only = bands.map { |band_arr| band_arr[0] }
  p names_only.uniq!
end
#metallum_fetch_bands("technical")
puts "ending seed.."
