#!/usr/bin/env ruby
require_relative "lib/voom"

s = "Hello, Terrible Memory Bank!"
i = 4193
f = 17.00091

m = Fiddle::Pointer.malloc 64

m.write([f, i, f])
p m.read(:string)
p Marshal.load(m.read(:string))


Value = Struct.new(:a, :b, :c)
v = Value.new(i, f, f + i)

p m
l = m.write(v)
p l
p m.size - l.size
p m.read(:string)
p Marshal.load(m.read(:string))
p m.read(:unmarshal)

l = m.write(Fiddle::Pointer::to_ptr(m))
l.write(v)
m.write(l)
p m
p m.read(:pointer)
vp = m.read(:pointer)
p vp
p vp.read(:unmarshal)
p m.read(:pointer).read(:unmarshal)

class Fiddle::Pointer
  def write_indirect(value)
    p = write(self)
    p.write(value)
    write(p)
  end
end

v = Value.new(-f, 0, f)
m.write_indirect(v)
p m.read(:pointer).read(:unmarshal)