require "fiddle"

module Fiddle
  SIGNED_INT_PATTERN = "l<"
  DOUBLE_FLOAT_PATTERN = "d"

  class BufferOverflow < IndexError
  	attr_reader :address, :request
    def initialize(address, request)
      @address = address
      @request = request
      super("Buffer overflow: requested #{request} bytes at #{address.inspect}")
    end
  end

  class Pointer
    def read_int
      self[0, Fiddle::ALIGN_INT].unpack(SIGNED_INT_PATTERN).first
    end

    def read_float
      self[0, Fiddle::ALIGN_DOUBLE].unpack(DOUBLE_FLOAT_PATTERN).first
    end

    def read_str
      self[Fiddle::ALIGN_INT, read_int]
    end

    def write_int(int)
      write([int].pack(SIGNED_INT_PATTERN), Fiddle::ALIGN_INT)
    end

    def write_float(float)
      write([float].pack(DOUBLE_FLOAT_PATTERN), Fiddle::ALIGN_DOUBLE)
    end

    def write_str(str)
      l = str.length
      address = write_int(l)
      if (padding = l % Fiddle::ALIGN_INT) > 0
        padding = Fiddle::ALIGN_INT - padding
        str += 0.chr * padding
        l = str.length
      end
  	  raise Fiddle::BufferOverflow.new(address, l) if l > address.size
      address[0, l] = str
  	  address + l
    end

	  private def write(str, aligned_length)
      raise BufferOverflow.new(self, aligned_length) if aligned_length > size
      self[0, aligned_length] = str
      self + aligned_length
	  end
  end
end