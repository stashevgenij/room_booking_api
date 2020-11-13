# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Room.first_or_create(number: 101)

users = [{ email: "homeless@example.com" }, { email: "homeless2@example.com" }]
users.each { |user| User.first_or_create user }