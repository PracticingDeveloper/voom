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

def create_item(i_name, i_price)
  @w.write_struct(Item, :name => i_name, :price => i_price)
end

def quantified_item(item_ref, i_quantity)
  @w.write_struct(ItemInCart, :item => item_ref, :quantity => i_quantity)
end

def create_list(*refs)
  first, *middle, last = refs

  head_ref = @w.write_int!(first)

  (middle + Array(last)).each do |e|
    @w.write_int(@w.pos + Voom::WORD_SIZE)
    @w.write_int(e)
  end

  @w.write_int(Voom::NULL)  

  head_ref
end

mem = Voom::Memory.new

@w = Voom::MemoryWriter.new(mem)

@w.write_ptr(@w.write_int(Voom::NULL))

eggs    = create_item("eggs", 0.19)
milk    = create_item("milk", 1.5)
bananas = create_item("bananas", 0.1)
apples  = create_item("apples", 0.75)

eleanor_cart = ShoppingCart.new(@w,
  create_list(
    quantified_item(eggs, 12),
    quantified_item(bananas, 5),
    quantified_item(apples, 4))
)

gregory_cart = ShoppingCart.new(@w,
  create_list(
    quantified_item(eggs, 6),
    quantified_item(milk, 3),
    quantified_item(apples, 4))
)

#gregory_cart.first.item.price = 2.5 # Make eggs much more expensive!
#gregory_cart.first.quantity = 10 # Change the amount of eggs in Gregory's Cart


puts "<ELEANOR>\n\n"
puts eleanor_cart

puts "........................................."

puts "<GREGORY>\n\n"
puts gregory_cart

gets
p mem