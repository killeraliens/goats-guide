# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Event.create!(title: "Graveland Fest", description: "Hyperdontia, Spectral Voice, Asphyx, Necrowretch, Grave", date: "#{Date.new(2019,6,22)} - #{Date.new(2019,6,24)}", time: "doors at 6pm")
Event.create!(title: "Mortuous", description: "Mortuous helps Tankcrimes and a ton of other sick label-mates take over the Oakland Metro tonight! This is their first show in five months. The full Carbonized Distro will also be available.", date: "#{Date.new(2019,9,11)}", time: "9pm")
