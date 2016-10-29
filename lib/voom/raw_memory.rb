require "fiddle"

module Voom
  class RawMemory
    WORD_SIZE   = 4
    SIGNED_INT_PATTERN = "l<"

    def initialize(bytes = 32)
      @data = Fiddle::Pointer.malloc(bytes)
    end

    def write_int(address, int)
      @data[address, WORD_SIZE] = [int].pack(SIGNED_INT_PATTERN)
    end

    def read_int(address)
      @data[address, WORD_SIZE].unpack(SIGNED_INT_PATTERN).first
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