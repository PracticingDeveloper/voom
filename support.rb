require_relative "lib/voom"

Voom.store = Voom::MemoryWriter.new

class Item < Voom::Type
  str    :name
  float  :price
end

class QuantifiedItem < Voom::Type
  int :quantity

  reference :item, Item
end

class ShoppingCart < Voom::Type
  list :data, QuantifiedItem

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
  Item.write(:name => i_name, :price => i_price)
end

def quantified_item(item_ref, i_quantity)
  QuantifiedItem.write(:item => item_ref, :quantity => i_quantity)
end