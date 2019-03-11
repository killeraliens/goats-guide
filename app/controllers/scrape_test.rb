require 'nokogiri'
require 'open-uri'
require 'mechanize'
# require 'fakeweb'

def songkick_fetch_event_show
  html_dir = File.join(__dir__, 'songkick.html')
  # file = open(html_dir).read
  # doc = Nokogiri::HTML(file)
  # p doc
  agent = Mechanize.new
  page = agent.get("file:///#{html_dir}")
  p page.css("time").text

end

songkick_fetch_band_results
