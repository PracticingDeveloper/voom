require_relative "lib/voom"

mem = Voom::Memory.new

mem.write_str(0x1337, "Hello, Terrible Memory Bank!")
p mem.read_str(0x1337)