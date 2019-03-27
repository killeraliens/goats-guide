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

  desc "Seeding custom band names (sync)"
  task create: :environment do
    # Band.destroy_all
    custom_bands = [
      "Slægt", "Obituary", "Wyrd", "Burial Invocation", "Mortuous", "Necrot", "MGLA", "Cult of Fire",
      "Petrification", "Mortiferum", "Tormentor", "Ultra Silvam", "Asphyx", "Phrenelith", "Horrendous", "Mortal Wound",
      "Deathtopia", "Hellripper", "Venefixion", "Incantation", "Hyperdontia", "Extremity", "Archgoat", "Genocide Pact",
      "Croc Noir", "Inferno", "Witch Vomit", "Witch Haven", "Obliteration", "Horna", "Cadaveric Incubator", "Butcher ABC",
      "Axeslasher", "Tomb Mold"
    ]
    puts "Creating #{custom_bands.size} bands with names ..."
    custom_bands.each do |band_name|
      Band.create(name: band_name)
    end
    p "Total bands in db: #{Band.all.size}"
  end
end
