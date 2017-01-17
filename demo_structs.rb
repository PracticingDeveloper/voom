#!/usr/bin/env ruby
require_relative "lib/voom"

m = Fiddle::Pointer.malloc 256

=begin
	define the structs etc. for the shopping cart example
	layout the structs manually in allocated memory

	# A cart is a list of line-items and their quantities
	Cart struct {
		item		Item
		count		Fixnum
		next		Cart | nil
	}
=end

Item = Struct.new(:name, :price)
class Item
	def write_to(ptr)
		ptr.write(name).write(price)
	end

	def read_from(ptr)
		self.name = ptr.read(:string)
		ptr += Fixnum::SIZE + Fiddle::Pointer::aligned_length(name)
		self.price = ptr.read(:float)
		ptr + Float::SIZE
	end
end

eggs = Item.new("eggs", 0.19)

milk = Item.new("milk", 1.09)
bananas = Item.new("bananas", 2.29)

eg = eggs.write_to(m)
mi = milk.write_to(eg)
ba = bananas.write_to(mi)

p eg, mi, ba

i = Item.new
i.read_from(m)
n = i.read_from(m)
p i

n = i.read_from(n)
p i

n = i.read_from(n)
p i

=begin
class Cart
	attr_reader :count, :item
	def initialize(item, tail=nil)
		@item = item
		@count = 1
	end

	def add(item)
		if @item == item
			@count += 1
		else
			tail.add
		end
	end

	def remove(item)
		if @item == item
			@count -= 1
			if @count == 0
				@item = tail.item
				@tail = tail.tail
			end
		else
			tail.remove
		end
	end

	private attr_reader :tail
end
=end