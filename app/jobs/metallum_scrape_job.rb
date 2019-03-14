require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'chromedriver-helper'
require 'watir'

class MetallumScrapeJob < ApplicationJob
  queue_as :default

  def perform
    browser = Watir::Browser.start("https://www.metal-archives.com/search/advanced/searching/bands?bandName=&genre=&country=&yearCreationFrom=&yearCreationTo=&bandNotes=&status=1&themes=&location=&bandLabelName=#bands")
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
      Band.create(name: band_arr[0])
    end
    browser.close
  end
end
