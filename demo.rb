#!/usr/bin/env ruby
require_relative "lib/voom"

mem = Voom::Memory.new

mem.write_int(0x1000, 1)
mem.write_int(0x1004, 2)
mem.write_int(0x1008, 4)
mem.write_int(0x100c, 8)

# these are our pointers
mem.write_int(0x2000, 0x1000)
mem.write_int(0x2004, 0x1004)
mem.write_int(0x2008, 0x1008)
mem.write_int(0x200c, 0x100c)


list = Voom::List.new(:int, mem, 0x2000)

node = list

[0x2004, 0x2008, 0x200c].each do |e|
  node.link(e)

  node = node.next
end

# just to show mutability
mem.write_int(0x100c, 32)

p list.data
p list.next.data
p list.next.next.data
p list.next.next.next.data


__END__
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