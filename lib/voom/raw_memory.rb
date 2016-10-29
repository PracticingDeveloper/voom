require "fiddle"

module Voom
  class RawMemory
    WORD_SIZE   = 4
    WORD_BOUNDARIES = [0, 8, 16, 24]

    def initialize(bytes = 32)
      @data = Fiddle::Pointer.malloc(bytes)
    end

    def write_int(address, int)
	    WORD_BOUNDARIES.each do |i|
        @data[address] = (int >> i) % 256
        address += 1
      end
    end

    def read_int(address)
      WORD_BOUNDARIES.inject(0) do |m, v|
        m += @data[address] << v
        address += 1
        m
      end
    end

    def write_str(address, str)
      write_int(address, str.length)
      address += WORD_SIZE
      @data[address, str.length] = str
      if (misalign = str.length % WORD_SIZE) != 0
        @data[address + str.length, misalign] = 0.chr * misalign
      end
    end

    def read_str(address)
      size = read_int(address)
      @data[address + WORD_SIZE, size]
    end
  end
end