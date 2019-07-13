# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Recipe.destroy_all
Ingredient.destroy_all

pizza = Recipe.create(name: "Pizza")
grilled_cheese = Recipe.create(name: "grilled cheese")

grilled_cheese.ingredients.create(name: "Pickles")

pizza.ingredients.create(name: "tomato sauce")
pizza.ingredients.create(name: "pepperoni")

cheese = pizza.ingredients.create(name: "cheese")
tomato = pizza.ingredients.create(name: "tomato")

grilled_cheese.ingredients << [cheese, tomato]
