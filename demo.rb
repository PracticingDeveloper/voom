#!/usr/bin/env ruby
require_relative "support"

Voom.store = Voom::MemoryWriter.new

eggs    = item("eggs", 0.19)
milk    = item("milk", 1.5)
bananas = item("bananas", 0.1)
apples  = item("apples", 0.75)

eleanor_cart = ShoppingCart.create(
  :data => [
    quantified_item(eggs, 12),
    quantified_item(bananas, 5),
    quantified_item(apples, 4)
  ]
)

gregory_cart = ShoppingCart.create(
  :data => [quantified_item(eggs, 6),
            quantified_item(milk, 3),
            quantified_item(apples, 4)])

### .................................

Item.update(eggs, :price => 2.5) # Change the price of eggs

eleanor_cart.first.quantity = 10 # Change the amount of eggs in Eleanors's Cart


### .................................

puts "<ELEANOR>\n\n"
puts eleanor_cart

puts "........................................."

puts "<GREGORY>\n\n"
puts gregory_cart

gets

p Voom.store