# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Plan.create(name: '1 Month', price: 500, unit_of_time: 'month', quantity: 1)
Plan.create(name: '3 Months', price: 1500, unit_of_time: 'month', quantity: 3)
Plan.create(name: '6 Months', price: 3000, unit_of_time: 'month', quantity: 6)
