namespace :band do
  desc "Scraping SK with all bands (async)"
  task create_events: :environment do
    bands = Band.all
    puts "Enqueuing #{bands.size} search scrapes with all band names..."
    bands.each do |band|
      SkScrapeJob.perform_later(band.id)
    end
  end

  desc "Scraping SK with a given band (sync)"
  task :create_events_for, [:band_id] => :environment do |t, args|
    band = Band.find(args[:band_id])
    puts "Enqueuing search scrape for #{band.name} ..."
    SkScrapeJob.perform_now(band.id)
  end
end
