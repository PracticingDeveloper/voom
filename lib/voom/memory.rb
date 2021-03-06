require_relative "list"
require "ostruct" # FIXME: remove

module Voom
  class Memory
    INT_PATTERN = "l<"
    FLOAT_PATTERN = "d"

    def initialize
      @data = []
    end

    def store(address, bytes)
      @data[address, bytes.length] = bytes
    end

    def retrieve(address, size)
      @data[address, size]
    end

    def write_int(address, int)
      store(address, [int].pack(INT_PATTERN).bytes)
    end

    def read_int(address)
      retrieve(address, WORD_SIZE).pack("C*").unpack(INT_PATTERN).first
    end

    def write_str(address, str)      
      write_int(address, str.length)
      store(address + WORD_SIZE, pad_byte_array(str.bytes))
    end

    def read_str(address)
      size = read_int(address)
      retrieve(address + WORD_SIZE, size).pack("C*")
    end

    def write_float(address, float)
      store(address, [float].pack(FLOAT_PATTERN).bytes)
    end

    def read_float(address)
      retrieve(address, 2 * WORD_SIZE).pack("C*").unpack(FLOAT_PATTERN).first
    end

    def to_s
      "      _0 _1 _2 _3     _4 _5 _6 _7     _8 _9 _A _B     _C _D _E _F\n" +

      pad_byte_array(@data).each_slice(16).map.with_index { |e,i| 
        next if e.compact.empty?

        ([('%.4x' % (i*16)) + ":" ]  + e.each_slice(4).map { |x| x.map { |z| '%.2x' % z.to_i } + [" | "] }).join(" ") 
      }.compact.join("\n")
    end

    private

    def pad_byte_array(array)
      array << 0 until array.length % WORD_SIZE == 0
    
      array
    end
  end
end