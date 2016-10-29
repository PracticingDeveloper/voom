require_relative "lib/voom"

mem = Voom::Memory.new

s = "Hello, Terrible Memory Bank!"
i = 4193

mem.write_str(0x1337, s)
p mem.read_str(0x1337)

mem.write_int(0x1337, i)
p mem.read_int(0x1337)


mem2 = Voom::RawMemory.new 32
mem2.write_int(0, i)
p mem2.read_int(0)

mem2.write_int(0, -i)
p mem2.read_int(0)

mem2.write_str(4, s)
p mem2.read_str(4)
