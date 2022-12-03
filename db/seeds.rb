# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "cleaning database"

puts "creating nap_spaces"

20.times do
  nap_space = NapSpace.create(
    user_id: rand(1..4),
    description: Faker::Company.catch_phrase,
    address: Faker::Address.full_address,
    cost_per_hr: Faker::Number.decimal(l_digits: 2),
    image_url: Faker::LoremFlickr.image(search_terms: ["sofa", "bed"], match_all: true)
  )
  puts "napspace with id: #{nap_space.id} has been created"
end

puts "finished"
