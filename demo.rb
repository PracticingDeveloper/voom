#!/usr/bin/env ruby
require_relative "lib/voom"

class Item < Voom::Type
  str    :name
  float  :price
end

mem = Voom::Memory.new

mem.write_int(0x0000, Voom::NULL) # NULL POINTER

mem.write_str(0x1000, "eggs")

mem.write_float(0x2000, 0.19)

mem.write_int(0x3000, 0x1000)
mem.write_int(0x3004, 0x2000)

item = Item.new(mem, 0x3000)
p item.name
p item.price

mem.write_float(0x2000, 0.79)
p item.name
p item.price

mem.write_str(0x1000, "garden fresh eggs")
p item.name
p item.price

__END__

mem.write_int(0x1000, 1)
mem.write_int(0x1004, 2)
mem.write_int(0x1008, 4)
mem.write_int(0x100c, 8)

mem.write_list(0x3000, :int, [0x1000, 0x1004, 0x1008, 0x100c])

list = mem.read_list(0x3000, :int)

# just to show mutability
mem.write_int(0x100c, 32)

p list.reduce(:+) #=> 1 + 2 + 4 + 32 = 39

s = "Hello, Terrible Memory Bank!"

mem.write_str(0x1337, s)
mem.write_int(0xbeef, 0x1337)
mem.write_int(0x1234, 0x1337)

p mem.read_ptr(0xbeef, :str)

mem.write_ptr(0xbeef, :str, "A new string")
p mem.read_ptr(0xbeef, :str)
p mem.read_str(0x1337)

i = 4193
f = 17.00091
mem.write_str(0x1337, s)
p mem.read_str(0x1337)

mem.write_int(0x1337, i)
p mem.read_int(0x1337)

mem.write_int(0x1337, -i)
p mem.read_int(0x1337)

mem.write_float(0x1337, f)
p mem.read_float(0x1337)

mem.write_float(0x1337, -f)
p mem.read_float(0x1337)

m = Fiddle::Pointer.malloc 64
begin
	m.write(0.chr * 59)
	m.write(0.chr * 60)
	m.write(0.chr * 61)
rescue Fiddle::BufferOverflow => e
	p e.message
end

m.write(i)
p m.read

n = m.write(-i)
p m.read

n.write(s)
p n.read :string

n.write(s[0, s.length - 1])
p n.read :string

o = n.write(s)
p n.read :string

q = o.write(f)
p o.read :float

q.write(-f)
p q.read :float

m.write([f, i, f])
p m.read :string
p Marshal.load(m.read :string)

Value = Struct.new(:a, :b, :c)
m.write(Value.new(i, f, f + i))
p m.read :string
p Marshal.load(m.read :string)
p m.read :unmarshal