#!/usr/bin/env ruby
require_relative "lib/voom"

s = "Hello, Terrible Memory Bank!"
i = 4193
f = 17.00091

m = Fiddle::Pointer.malloc 64

begin
	(55..58).each do |l|
		p "malloc string with #{l} bytes"
		m.write(0.chr * l)
	end
rescue Fiddle::BufferOverflow => e
	p e.message
end

m.write(i)
p m.read

n = m.write(-i)
p m.read

n.write(s)
p n.read(:string)

n.write(s[0, s.length - 1])
p n.read(:string)

o = n.write(s)
p n.read(:string)

q = o.write(f)
p o.read(:float)

q.write(-f)
p q.read(:float)