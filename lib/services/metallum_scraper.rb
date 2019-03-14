require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'chromedriver-helper'
require 'watir'



#browser.close
def metallum_fetch_bands(genre)
  #browser = Watir::Browser.start("https://www.metal-archives.com/search/advanced/searching/bands?bandName=&genre=&country=&yearCreationFrom=&yearCreationTo=&bandNotes=&status=1&themes=&location=&bandLabelName=#bands")
  browser = Watir::Browser.start("https://www.metal-archives.com/search/advanced/searching/bands?bandName=&genre=#{genre}+&country=&yearCreationFrom=&yearCreationTo=&bandNotes=&status=1&themes=&location=&bandLabelName=#bands")
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
      bands << band_arr
    end

    browser.a(class: ["next", "paginate_button"], text: "Next").click
    sleep(2)

  end
  p bands.count
  browser.close
end

metallum_fetch_bands("technical")

