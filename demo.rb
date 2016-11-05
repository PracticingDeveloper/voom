#!/usr/bin/env ruby
require_relative "lib/voom"

s = "Hello, Terrible Memory Bank!"
i = 4193
f = 17.00091

mem = Voom::Memory.new
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