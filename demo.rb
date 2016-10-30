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


mem2 = Fiddle::Pointer.malloc 64
mem2.write_int(0, i)
p mem2.read_int(0)

mem2.write_int(0, -i)
p mem2.read_int(0)

mem2.write_str(4, s)
p mem2.read_str(4)

mem2.write_str(4, s[0, s.length - 1])
p mem2.read_str(4)

mem2.write_str(4, s)
p mem2.read_str(4)

mem2.write_float(4 + s.aligned_length, f)
p mem2.read_float(4 + s.aligned_length)

mem2.write_float(4 + s.aligned_length + 8, -f)
p mem2.read_float(4 + s.aligned_length + 8)