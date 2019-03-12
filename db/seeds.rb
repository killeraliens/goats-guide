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
        datetime = event.search('time')
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
        address = "#{city} #{state} #{country}"
        # page = agent.get(event_url)
        # address = page.search('.venue-hcard').text.gsub("\n", ' ').squeeze(' ').strip
        venue = Venue.create(name: venue, address: address)
        Event.create(date: datetime, time: datetime, title: title, description: description, venue: venue)
      end
      disabled_next_button = page.search('.next_page.disabled')
      if disabled_next_button.text == ""
        url = "https://www.songkick.com/search?page=#{page_num + 1}&per_page=30&query=#{band_name}&type=upcoming" # "Youre on one of the previous pages"
        # html_file = open(url).read
        # page = Nokogiri::HTML(html_file) # "Youre on one of the previous pages"
        page = agent.get(url)
      else
        another_page = false # "Youre on the last page"
      end
      page_num += 1
    end
  end
songkick_fetch_index("obituary")
puts "ending seed.."

# puts "seeding events.."
# Event.create(title: "Graveland Fest", description: "Hyperdontia, Spectral Voice, Asphyx, Necrowretch, Grave", date: "#{Date.new(2019,6,22)} - #{Date.new(2019,6,24)}", time: "doors at 6pm")
# Event.create(title: "Mortuous", description: "Mortuous helps Tankcrimes and a ton of other sick label-mates take over the Oakland Metro tonight! This is their first show in five months. The full Carbonized Distro will also be available.", date: "#{Date.new(2019,9,11)}", time: "9pm")
