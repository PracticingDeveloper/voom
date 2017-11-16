#!/usr/bin/env ruby
require_relative "lib/voom"

class Item < Voom::Type
  str    :name
  float  :price
end

# FIXME: Rename ItemWithQuantity?
class ItemInCart < Voom::Type
  int :quantity

  reference :item, Item
end

class ShoppingCart < Voom::Type
  list :data, ItemInCart

  include Enumerable

  def each(&b)
    data.each(&b)
  end

  def to_s
    "In your cart: \n\n" + 

    map { |e| "- #{e.item.name} @ #{e.item.price} x #{e.quantity}" }.join("\n") +

    "\n\nTOTAL: " + 
    ('%.2f' % reduce(0) { |s,e| s + (e.item.price * e.quantity)}) 
  end
end 

### .................................

def item(i_name, i_price)
  Item.allocate(:name => i_name, :price => i_price)
end

def quantified_item(item_ref, i_quantity)
  ItemInCart.allocate(:item => item_ref, :quantity => i_quantity)
end
  
### .................................

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

gregory_cart.first.item.price = 2.5 # Make eggs much more expensive!
eleanor_cart.first.quantity = 10 # Change the amount of eggs in Eleanors's Cart

### .................................

puts "<ELEANOR>\n\n"
puts eleanor_cart

puts "........................................."

puts "<GREGORY>\n\n"
puts gregory_cart

gets

p Voom.store