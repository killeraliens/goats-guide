require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'chromedriver-helper'
# https://github.com/watir/watir_meta/wiki/Cheat-Sheet
# https://nicksardo.wordpress.com/2014/11/17/screen-scraping-in-ruby-with-watir-and-nokogiri/
require 'watir'
require 'pry-byebug'

puts "seeding .."
#Venue.destroy_all
#Band.destroy_all

# def songkick_fetch_index(band_name)
#     # band_names = BnameScrapeJob.perform (if self.perform)
#     url = "https://www.songkick.com/search?page=1&per_page=30&query=#{band_name}&type=upcoming"

#     agent = Mechanize.new
#     page = agent.get(url)

#     pagination_with_link = page.search("div.pagination a" )
#     no_results = page.search("div.no-results h2").text.split(' ').include?("Sorry,")

#     another_page = true
#     page_num = 1

#     while another_page == true && !no_results
#       page.search('.concert').each do |event|
#         # page.search('h1').text.gsub("\n", ' ').squeeze(' ').strip
#         datetime = event.search('time')[0]['datetime']
#         time = DateTime.parse(datetime)
#         time = "#{time.hour}:#{time.min}"
#         p title = event.search('.summary a strong').text
#         p description = event.css('.summary a').text
#         location = event.css('.location').text.gsub("\n", '').strip.split(/\s*,\s*/)
#         if location.count < 3
#           p venue name = title
#         else
#           venue_name = location[0]
#         end
#         root = "https://www.songkick.com"
#         href = event.search('.summary a')[0]['href']
#         p event_url = root + href

#         page = agent.get(event_url)

#         raw_address = page.search('.venue-hcard').text.split("\n")
#         p raw_address = raw_address.each { |line| line.strip! }.select { |item| item != "" }.first(5)
#         if raw_address.count == 5
#           street_address = raw_address[0]
#           zipcode = raw_address[1]
#           city_state_country = raw_address[2].split(',')
#           city = city_state_country[0]
#           state = city_state_country[1].strip
#           country = city_state_country[2].strip
#         elsif raw_address.count == 4
#           raw_address
#           street_address = raw_address[0]
#           zipcode = raw_address[1]
#           city_state_country = raw_address[2].split(',')
#           city = city_state_country[0]
#           country = city_state_country[1].strip
#         elsif raw_address.count == 1
#           city_country = raw_address.join(",").split(',')
#           city = city_country[0]
#           country = city_country[1]
#         end
#         venue = Venue.new(name: venue_name, street_address: street_address, city: city, state: state, country: country)
#         if venue.save
#           event = Event.create(date: datetime, time: time, title: title, description: description, venue: venue, url_link: event_url)
#           puts "created event for #{event.date} at #{venue.name}"
#         else
#           venue = Venue.find_by(name: venue_name, street_address: street_address)
#           event = Event.create(date: datetime, time: time, title: title, description: description, venue: venue, url_link: event_url)
#           puts "#{venue.name} already created, created this event for #{event.date}"
#         end
#         sleep(0.5)
#       end
#       url = "https://www.songkick.com/search?page=#{page_num}&per_page=30&query=#{band_name}&type=upcoming"
#       page = agent.get(url)
#       disabled_next_button = page.search('div.pagination span')
#       p disabled_next_button.text
#       if disabled_next_button.text.include?("Next") == false && pagination_with_link.text != ""
#         url = "https://www.songkick.com/search?page=#{page_num + 1}&per_page=30&query=#{band_name}&type=upcoming"
#         puts "next page buttonn is not disabled"
#         page = agent.get(url)
#       else
#         puts "last page"
#         another_page = false
#       end
#       page_num += 1
#       puts "on to next page"
#     end
# end

def songkick_fetch_index(band_name)
  url = "https://www.songkick.com/search?page=1&per_page=30&query=#{band_name}&type=upcoming"
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
        if country == "US" || country == "Canada"
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
          p end_date = Date.parse(end_date_str)
        end
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
            # raise "expected lineup to be found"
            p description = page.search('div.row.component.brief div.location').text.strip.gsub("\n", ' ').squeeze(' ')
          else
            p description = page.search('div.line-up span').text.strip.gsub("\n", ', ').squeeze(' ')
          end
        elsif event_type == "festival"
          # raise "expected fest details to be found" if page.search('div.component.festival-details ul').empty?
          p description = page.search('div.component.festival-details ul').text.strip.gsub("\n", ', ').squeeze(' ')
        end
        venue = Venue.new(name: venue_name, info: location_details, city: city, state: state, country: country)
        if venue.save
          event = Event.create(date: date, end_date: end_date, time: time, title: title, description: description, venue: venue, url_link: event_url)
          puts "created event for #{event.date} at #{venue.name}"
        else
          venue = Venue.find_by(name: venue_name, city: city)
          event = Event.create(date: date, end_date: end_date, time: time, title: title, description: description, venue: venue, url_link: event_url)
          puts "#{venue.name} already created, created this event for #{event.date}"
        end
        sleep(0.5)
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
end
#songkick_fetch_index("mortuous")


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
metallum_fetch_bands("doom/black")
puts "ending seed.."
