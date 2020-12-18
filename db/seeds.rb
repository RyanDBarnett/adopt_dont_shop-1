# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


@shelter = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
@shelter.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
@shelter.pets.create!(image:"", name: "Bubba", description: "dog", approximate_age: 1, sex: "male")
Application.create!(
  name: "John Doe",
  address: '321 Happy Ave',
  city: 'Irvine',
  state: 'CA',
  zip: 90323,
  description: nil,
  status: 'In Progress'
)
