require_relative "../lib/voom"

raw_memory = Voom::Memory.new

raw_memory.store(0x1234, [0xab, 0xcd, 0xef])

p Voom.hex(raw_memory.retrieve(0x1234, 3))
p Voom.hex(raw_memory.retrieve(0x1234, 2))

puts raw_memory