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
m.write_int(i)
p m.read_int

n = m.write_int(-i)
p m.read_int

n.write_str(s)
p n.read_str

n.write_str(s[0, s.length - 1])
p n.read_str

o = n.write_str(s)
p n.read_str

q = o.write_float(f)
p o.read_float

q.write_float(-f)
p q.read_float