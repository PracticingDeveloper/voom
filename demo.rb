require_relative "lib/voom"

s = "Hello, Terrible Memory Bank!"
i = 4193

mem = Voom::Memory.new
mem.write_str(0x1337, s)
p mem.read_str(0x1337)

mem.write_int(0x1337, i)
p mem.read_int(0x1337)


mem2 = Fiddle::Pointer.malloc 64
mem2.write_int(0, i)
p mem2.read_int(0)
p mem2.read_int(0)

mem2.write_int(0, -i)
p mem2.read_int(0)
p mem2.read_int(0)

mem2.write_str(4, s)
p mem2.read_str(4)
puts mem2
mem2.read_str(4)
p mem2.read_str(4)
p mem2.read_str(4)

mem2.write_str(4, s[0, s.length - 1])
p mem2.read_str(4)