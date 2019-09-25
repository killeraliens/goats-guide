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
    #Band.destroy_all
    custom_bands = [
      "Slægt", "Obituary", "Wyrd", "Burial Invocation", "Mortuous", "Necrot", "MGLA", "Cult of Fire",
      "Petrification", "Mortiferum", "Tormentor", "Ultra Silvam", "Asphyx", "Phrenelith", "Horrendous", "Mortal Wound",
      "Deathtopia", "Hellripper", "Venefixion", "Incantation", "Hyperdontia", "Extremity", "Archgoat", "Genocide Pact",
      "Croc Noir", "Entombed A.D.", "Witch Vomit", "Witch Haven", "Horna", "Cadaveric Incubator", "Butcher ABC",
      "Axeslasher", "Tomb Mold", "Teethgrinder", "Graceless", "Soulburn", "Fabulous Desaster", "Suffocation", "Vastum",
      "Demilich", "Korpse", "Wormrot", "Disma", "Entrails", "Dismember", "Nokturnal Mortum", "Kroda", "Slayer",
      "Agoraphobic Nosebleed", "Abhorrence", "Demigod", "Gorgoroth", "Vanhelgd", "Mass Grave", "Necrovation", "Deströyer 666",
      "Tsjuder", "Winterfylleth", "Hypocrisy", "Watain", "At The Gates", "Cruciamentum", "Dead Congregation", "Sepulcher",
      "Necromaniac", "Galvanizer", "Funebrarum", "Anatomia", "Spectral Voice", "Corpsessed", "Ritual Necromancy", "Exhumed",
      "Mercyful Fate", "King Diamond", "Gatecreeper", "Moonsorrow", "Bloodbath", "Vomitory", "Skeletal Remains", "Skelelethal",
      "Obliteration", "Vassafor", "Evoken", "Rippikoulu", "Fetid", "Weregoat", "Sabbatory", "Necrophobic", "Hate Eternal",
      "Cerebral Rot", "Concrete Winds", "Krypts", "Cariac Arrest", "Dipygus", "Deiquisitor", "Abyssal", "Revenge", "Bonehunter",
      "Dead Void", "Deathrite", "Darvaza", "Atavisma", "Heinous", "Harakiri For The Sky", "Ruin", "Mammoth Grinder", "Funeralium",
      "Torture Rack", "Taphos", "Dispirit", "Cosmic Void Ritual", "Black Curse", "Vorum", "Ossuary", "Ceremented", "Cenotaph",
      "Haggus", "Agothacles", "Necrowretch", "Destroyer 666", "Immolation", "Burning Witches", "Deicide", "Under The Church",
      "Sinister", "Feretory", "Scraplord", "Master", "Wolves In The Throne Room", "Escuela Grind", "Judiciary", "Morbid Angel",
      "Gutslit", "Raven Throne", "Uada", "Deathrite", "Veneficium", "Bethlehem", "Ravencult", "Faceless Burial", "Funeral Moth"
    ]
    puts "Creating #{custom_bands.size} bands with names ..."
    custom_bands.each do |band_name|
      Band.create(name: band_name)
    end
    p "Total bands in db: #{Band.all.size}"
  end
end
