require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'chromedriver-helper'
require 'watir'
require 'pry-byebug'
# https://github.com/watir/watir_meta/wiki/Cheat-Sheet
# https://nicksardo.wordpress.com/2014/11/17/screen-scraping-in-ruby-with-watir-and-nokogiri/

puts "seeding .."
# Event.destroy_all
# Venue.destroy_all
# Band.destroy_all
# ScrapeJob.destroy_all
# User.destroy_all
# puts "destroying all"

# 5.times do
#   user = User.create!(username: Faker::Internet.username(8), email: Faker::Internet.email, password: Faker::Internet.password(8))
#   venue = Venue.create!(name: Faker::Games::HalfLife.location, city: 'los angeles', country: 'us')
#     2.times do
#       Event.create!(title: Faker::Music::RockBand.name, description: Faker::Movies::VForVendetta.speech, date: Faker::Date.forward(23), end_date: Faker::Date.forward(23), time: Faker::Superhero.descriptor, venue: venue, event_creator: user)
#     end
# end
# 5.times do
#   User.create!(username: Faker::Internet.username(8), email: Faker::Internet.email, password: Faker::Internet.password(8))
# end


def songkick_fetch_index(band_name)
  url = "https://www.songkick.com/search?page=1&per_page=30&query=#{band_name}&type=upcoming"
  # scrape_job = ScrapeJob.create(name: "Songkick")
  agent = Mechanize.new
  page = agent.get(url)
  another_page = true
  page_num = 1
  pagination_with_link = page.search("div.pagination a" )
  no_results = page.search("div.no-results h2")
  while another_page == true && no_results.empty?
    all_events = page.search('div.component.search.event-listings.events-summary ul li')
    all_events.each do |event|
      card_summary = event.search('.summary').text.downcase
      if card_summary.include?(band_name.downcase) || card_summary.include?("metal")
        time = "TBD"
        p city_country = event.search('p.location').text.strip.split(', ').reverse
        p country = city_country[0]
        if country.include?("US") || country.include?("Canada") || country.include?("Australia")
          p state = city_country[1]
          p city = city_country[2]
        else
          p city = city_country[1]
        end
        root = "https://www.songkick.com"
        href = event.search('.summary a')[0]['href']
        event_url = root + href

        page = agent.get(event_url)

        page.search('div.event-header').empty? ? event_type = "festival" : event_type = "concert"

        p event_type
        dates = page.search('div.date-and-name p')
        multi_date = true if dates.text.split.count > 4
        date_str = dates.text.split.first(4).join(', ')
        p date = Date.parse(date_str)
        if multi_date
          end_date_str = dates.text.split.last(4).join(', ')
          end_date = Date.parse(end_date_str)
        end
        p end_date.nil? ? end_date = date : end_date
        p title = page.search('h1').text.strip
        venue = page.search('div.component.venue-info')
        if venue.empty?
          p venue_name = title + "(venue TBD)"
          p location_details = page.search('p.first-location').text
        else
          venue_details = page.search('div.venue-info-details')
          p venue_name = venue_details.search('a.url').first.text.upcase
          raw_address = venue_details.search('.venue-hcard').text.split("\n")
          raw_address = raw_address.each { |line| line.strip! }.select { |item| item != "" }.first(5)
          p location_details = raw_address.join(', ')
        end
        if event_type == "concert"
          if page.search('div.line-up').empty?
            p description = page.search('div.row.component.brief div.location').text.strip.gsub("\n", ' ').squeeze(' ')
          else
            p description = page.search('div.line-up span').text.strip.gsub("\n", ', ').squeeze(' ')
          end
        elsif event_type == "festival"
          p description = page.search('div.component.festival-details ul').text.strip.gsub("\n", ', ').squeeze(' ')
        end

        # IMAGE GETTING
        if page.search('div.media-group').present?
          media = page.search('div.media-group')
          if media.text.include?('Photos') || media.text.include?('Posters')
            all = media.search('div.media-element a')
            links = all.select { |link| link['href'].include?('images') || link['href'].include?('posters') }
            p image_link = "https://www.songkick.com" + links.first['href']
          end
          page = agent.get(image_link)
          if page.search('div.image img').present?
            tail =  page.search('div.image img').first['src']
            p fetch_photo = "https:" + tail
          end
        end
        ######
        venue = Venue.new(name: venue_name, info: location_details, city: city, state: state, country: country)
        if venue.save
          event = Event.create(
            date: date,
            end_date: end_date,
            time: time,
            title: title,
            description: description,
            venue: venue,
            url_link: event_url,
            fetch_photo: fetch_photo
            # event_creator: scrape_job
          )
          puts "created event for #{event.date} at #{venue.name}"
        else
          puts "#{venue.name} already created"
          venue = Venue.find_by(name: venue_name, city: city)
          event = Event.new(
            date: date,
            end_date: end_date,
            time: time,
            title: title,
            description: description,
            venue: venue,
            url_link: event_url,
            fetch_photo: fetch_photo
            # event_creator: scrape_job
          )
          if event.save
            puts "This is a new event"
          else
            puts "This event was already made and should be updated. Updating.."
            event = Event.find_by(date: event.date, venue: event.venue)
            event&.update(
              # date: date,
              # end_date: end_date,
              # time: time,
              # title: title,
              # description: description,
              # venue: venue,
              # url_link: event_url,
              fetch_photo: fetch_photo
            )
            puts "updated #{event.title}-#{event.id}"
          end
        end
        sleep(2)
        p "--------------"
      end
    end
    url = "https://www.songkick.com/search?page=#{page_num}&per_page=30&query=#{band_name}&type=upcoming"
    page = agent.get(url)
    disabled_next_button = page.search('div.pagination span')
    if disabled_next_button.text.include?("Next") == false && pagination_with_link.empty? == false
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
  # scrape_job.events.count.zero? ? scrape_job.destroy : scrape_job
end
songkick_fetch_index("obituary")


def metallum_fetch_bands(genre)
  #browser = Watir::Browser.start("https://www.metal-archives.com/search/advanced/searching/bands?bandName=&genre=&country=&yearCreationFrom=&yearCreationTo=&bandNotes=&status=1&themes=&location=&bandLabelName=#bands")
  browser = Watir::Browser.start("https://www.metal-archives.com/search/advanced/searching/bands?bandName=&genre=#{genre}+&country=&yearCreationFrom=&yearCreationTo=&bandNotes=&status=1&themes=&location=&bandLabelName=#bands")
  page = Nokogiri::HTML(browser.html)

    bands = []
    entry_count = page.search("div.dataTables_info").last.text.split(' ')
    current_page = entry_count[3]
    last_page = entry_count[5]
    trs = page.search("tbody tr")

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
  bands.each do |band_arr|
    band = Band.new(name: band_arr[0])
    if band.save
      puts "band saved"
    else
      puts "band not saved"
    end
  end
  browser.close
end
# metallum_fetch_bands("doom/black")
puts "ending seed.."
