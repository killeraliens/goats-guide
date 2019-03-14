require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'chromedriver-helper'
require 'watir'



#browser.close

def bcamp_fetch_index
  # browser = Watir::Browser.new
  # browser.goto('https://bandcamp.com/tag/metal')
  browser = Watir::Browser.start("https://bandcamp.com/tag/metal")
  page = browser.html
  page = Nokogiri::HTML(page)


  pager = page.search('div.pager')
  pager.text == '' ? pager = false : pager = true

  if pager == false
    # artists = page.search('.artist')
    # button = browser.button(class: "view-more")
    # p button.text
    # browser.button(class: "view-more").click
    # browser.execute_script("window.scrollBy(0,6000)")
    # artists.each do |item|
    #   puts item.text.gsub("\n", " ").strip
    # end
    # last_artist = page.search('.col .col-2-12 .dig-deeper-item item').first.text
    # p last_artist.gsub("\n", " ").squeeze(" ")
    # sleep(10)
    puts "javascripted"
  else
    page_num = page.search('.pagelist li span').text.to_i
    until page_num.to_s.include?('10')
      artists = page.search('.itemsubtext')
      artists.each do |item|
        # Band.create(name: item)
        puts item.text.gsub("\n", " ").strip
      end
      page_num += 1
      browser.a(class: ["pagenum", "round4"], text: "#{page_num}").click
    end
  end
end

# bcamp_fetch_index

def bcamp_local
  html_dir = File.join(__dir__, 'bandcamp_metal.html')
  file = open(html_dir).read
  page = Nokogiri::HTML(file)

  artists = page.search('.itemsubtext')
  artists.each do |item|
    # Band.create(name: item)
    puts item.text.gsub("\n", " ").strip
  end

end

#bcamp_local
