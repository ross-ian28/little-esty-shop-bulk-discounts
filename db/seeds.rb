# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
merchant1 = Merchant.create(name: "Pabu")
discount1 = merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)
discount2 = merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 5)
discount3 = merchant1.discounts.create!(percentage_discount: 50, quantity_threshold: 8)
