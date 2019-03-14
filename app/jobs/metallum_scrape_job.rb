require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'chromedriver-helper'
require 'watir'

class MetallumScrapeJob < ApplicationJob
  queue_as :default

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
      page = Nokogiri::HTML(browser.html)
      entry_count = page.search("div.dataTables_info").last.text.strip.split(' ')
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
    return names_only.uniq!
    #RETURN OF ARRAY WILL BE DELETED ONCE BAND CREATION CODE IS UPDATED
    #NEED TO ADD RESULTS LIMITING LOGIC STILL (.unique logic on name column validations)(where do i filter chinese characters)
  end
end
