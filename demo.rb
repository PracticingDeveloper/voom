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
  item_ref = @w.write_str!(i_name)

  @w.write_float!(i_price)

  item_ref
end

def add_to_cart(item_ref, i_quantity)
  added_ref = @w.write_int!(i_quantity)
  @w.write_ptr(item_ref)

  added_ref
end


mem = Voom::Memory.new
@w = Voom::FancyMemoryWriter.new(mem)

@w.write_ptr(@w.write_int(Voom::NULL))

eggs    = create_item("eggs", 0.19)
milk    = create_item("milk", 1.5)
bananas = create_item("bananas", 0.1)

i1 = add_to_cart(eggs, 12)
i2 = add_to_cart(bananas, 5)
i3 = add_to_cart(milk, 3)

list = @w.write_int(i1)

@w.write_int(@w.pos + Voom::WORD_SIZE)
@w.write_int(i2)

@w.write_int(@w.pos + Voom::WORD_SIZE)
@w.write_int(i3)

@w.write_int(Voom::NULL)

list_ref = @w.write_int(list)
cart = ShoppingCart.new(@w, list_ref)

puts cart
gets
p mem