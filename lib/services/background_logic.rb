
$ rails g job bname_scrape
$ rails g job sk_scrape

#PERFORM NAME SCRAPE ONCE A WEEK
class BnameScrapeJob
  require 'nokogiri'
  require 'open-uri'
  require 'mechanize'
  require 'chromedriver-helper'
  require 'watir'
  queue_as :default #??


  def perform
    #WILL DESTROY ALL BAND INSTANCES WHEN RAN
    browser = Watir::Browser.start("https://www.metal-archives.com/search/advanced/searching/bands?bandName=&genre=&country=&yearCreationFrom=&yearCreationTo=&bandNotes=&status=1&themes=&location=&bandLabelName=#bands")
    page = browser.html
    page = Nokogiri::HTML(page)

    bands = []
      trs = page.search("tbody tr")
      entry_count = page.search("div.dataTables_info").last.text.strip.split(' ')
      current_page = entry_count[3]
      last_page = entry_count[5]

    until current_page == last_page
      page = browser.html
      page = Nokogiri::HTML(page)
      entry_count = page.search("div.dataTables_info").last.text.strip.split(' ')
      current_page = entry_count[3]
      last_page = entry_count[5]
      p current_page
      p last_page
      trs.each do |tr|
        td = tr.search("td")
        band_arr = td.map { |i| i.text.strip }
        #WILL CREATE BAND INSTANCES (DISCONNECTED TABLE FOR NOW)
        bands << band_arr
      end
      browser.a(class: ["next", "paginate_button"], text: "Next").click
      sleep(2)
    end
    return bands
    browser.close
    #RETURN OF ARRAY WILL BE DELETED ONCE BAND CREATION CODE IS UPDATED
    #NEED TO ADD RESULTS LIMITING LOGIC STILL (.unique logic on name column validations)(where do i filter chinese characters)
  end
end




#PERFORM NAME SCRAPE ONCE A WEEK
class SkScrapeJob
  require 'nokogiri'
  require 'open-uri'
  require 'mechanize'
  queue_as :default #??????

  def perform(band_name) #TAKES BAND NAMES FROM BANDS TABLE AND EXECUTES SEARCH ON EACH NAME COLUMN
    band_name = "obituary"
    url = "https://www.songkick.com/search?page=1&per_page=30&query=#{band_name}&type=upcoming"

    agent = Mechanize.new
    page = agent.get(url)

    another_page = true
    page_num = 1

    while another_page == true

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
  #perform("obituary") #PERFORM ON ALL NAMES IN BANDS TABLE
end


#REDIS SETUP
#SIDEKICK SETUP

#ADD CONFIG SIDECKICK TO application.rb
# config/routes.rb
# Rails.application.routes.draw do
#   # Sidekiq Web UI, only for admins.
#   require "sidekiq/web"
#   authenticate :user, lambda { |u| u.admin } do
#     mount Sidekiq::Web => '/sidekiq'
#   end
# end

# config/sidekiq.yml
# :concurrency: 3
# :timeout: 60
# :verbose: true
# :queues:  # Queue priority: https://github.com/mperham/sidekiq/wiki/Advanced-Options
#   - default
#   - mailers



