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