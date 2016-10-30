module Voom
  WORD_SIZE = 4

  class Memory
    INT_PATTERN = "l<"
    FLOAT_PATTERN = "d"

    def initialize
      @data = []
    end

    def write_int(address, int)
      store(address, [int].pack(INT_PATTERN).bytes)
    end

    def read_int(address)
      retrieve(address, 4).pack("C*").unpack(INT_PATTERN).first
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

    def store(address, bytes)
      @data.insert(address, *bytes)
    end

    def retrieve(address, bytes)
      @data.slice(address, bytes)
    end

    private

    def pad_byte_array(array)
      array << 0 until array.length % WORD_SIZE == 0
    
      array
    end
  end
end