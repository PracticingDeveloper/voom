#!/usr/bin/env ruby
require_relative "lib/voom"

class Item < Voom::Type
  str    :name
  float  :price
end

class ItemInCart < Voom::Type
  int :quantity

  reference :item, Item
end

class ShoppingCart < Voom::Type
  list :data, ItemInCart

  include Enumerable

  def each
    data.each { |e| yield e }
  end

  def to_s
    map { |e| "- #{e.item.name} @ #{e.item.price} x #{e.quantity}" }.join("\n") +

    "\n\nTOTAL: " + 
    ('%.2f' % reduce(0) { |s,e| s + (e.item.price * e.quantity)}) 
  end
end 

def create_item(i_name, i_price)
  raise if i_name.length > 128

  start_pos = @w.v_pos

  item_ref = @w.write_str!(i_name)
  @w.seek(start_pos + 128)

  @w.write_float!(i_price)

  item_ref
end


# quantity | (ptr to quantity | ptr to item)  
# reti
#
# FIXME: Figure out a way to split out the values (quantity and item ref, from the returned pointer) 
#
def add_to_cart(item_ref, i_quantity)
  quantity = @w.write_int(i_quantity)
 
  item_in_cart = @w.write_ptr(quantity)
  @w.write_ptr(item_ref)

  item_in_cart
end


mem = Voom::Memory.new
@w = Voom::FancyMemoryWriter.new(mem)

@w.write_ptr(@w.write_int(Voom::NULL))


i1 = add_to_cart(create_item("eggs", 0.19), 12)
i2 = add_to_cart(create_item("bananas", 0.1), 5)
i3 = add_to_cart(create_item("milk", 1.5), 3)

list = @w.write_int(i1)


@w.write_int(@w.pos + Voom::WORD_SIZE)
@w.write_int(i2)

@w.write_int(@w.pos + Voom::WORD_SIZE)
@w.write_int(i3)

@w.write_int(Voom::NULL)

list_ref = @w.write_int(list)
cart = ShoppingCart.new(mem, list_ref)

puts cart

p mem