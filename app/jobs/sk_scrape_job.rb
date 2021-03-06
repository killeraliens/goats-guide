require 'nokogiri'
require 'open-uri'
require 'mechanize'

class SkScrapeJob < ApplicationJob
  queue_as :default

  def perform(band_id)
    band = Band.find(band_id)
    url = "https://www.songkick.com/search?page=1&per_page=30&query=#{band.name}&type=upcoming"
    agent = Mechanize.new
    page = agent.get(url)
    another_page = true
    page_num = 1
    pagination_with_link = page.search("div.pagination a")
    no_results = page.search("div.no-results h2")
    while another_page == true && no_results.empty?
      all_events = page.search('div.component.search.event-listings.events-summary ul li')
      all_events.each do |event|
        card_summary = event.search('.summary').text.downcase
        if card_summary.include?(band.name.downcase) || card_summary.include?("metal")
          time = "TBD"
          city_country = event.search('p.location').text.strip.split(', ').reverse
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
            p venue_name = title + "(venue NA)"
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
              #p description = page.search('div.row.component.brief div.location').text.strip.gsub("\n", ' ').squeeze(' ')
              p description = nil
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
              if page.search('div.attribution').present?
                p credit = page.search('div.attribution').text.gsub("\n", "").squeeze(" ").strip
              end
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
                fetch_photo: fetch_photo,
                photo_credit: credit,
                source: "Songkick"
              )
              puts "new venue added: #{venue.name}"
              puts "created event for #{event.date} at #{venue.name}"
              p "--------------"
            else
              venue = Venue.find_by(name: venue_name, city: city)
              event = Event.new(
                date: date,
                end_date: end_date,
                time: time,
                title: title,
                description: description,
                venue: venue,
                url_link: event_url,
                fetch_photo: fetch_photo,
                photo_credit: credit,
                source: "Songkick"
              )
              puts "venue exists: #{venue.name}"
              if event.save
                puts "This is a new event at venue: #{venue.name}"
                p "--------------"
              else
                puts "This event was already made and should be updated. Updating.."
                event = Event.find_by(date: event.date, venue: event.venue)
                event&.update(
                  date: date,
                  end_date: end_date,
                  time: time,
                  title: title,
                  description: description,
                  # venue: venue,
                  url_link: event_url,
                  fetch_photo: fetch_photo,
                  photo_credit: credit,
                  source: "Songkick"
                )
                puts "updated #{event.title}-#{event.id}"
                p "--------------"
              end
            end
          sleep(2)
        end
      end
      url = "https://www.songkick.com/search?page=#{page_num}&per_page=30&query=#{band.name}&type=upcoming"
      page = agent.get(url)
      disabled_next_button = page.search('div.pagination span')
      if disabled_next_button.text.include?("Next") == false && pagination_with_link.empty? == false
        url = "https://www.songkick.com/search?page=#{page_num + 1}&per_page=30&query=#{band.name}&type=upcoming"
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
end
