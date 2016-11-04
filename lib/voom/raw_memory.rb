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
      write([int].pack(SIGNED_INT_PATTERN))
    end

    def write_float(float)
      write([float].pack(DOUBLE_FLOAT_PATTERN))
    end

    def write_str(str)
      write(Pointer::pstring(str))
    end

	  private def write(str)
      raise BufferOverflow.new(self, str.length) if str.length > size
      self[0, str.length] = str
      self + str.length
	  end

    def self.pstring(str)
      Pointer::align([str.length].pack(SIGNED_INT_PATTERN) + str)
    end

    def self.align(str)
      padding = str.length % Fiddle::ALIGN_INT
      if padding > 0
        padding = Fiddle::ALIGN_INT - padding
      end
      str += 0.chr * padding
    end
  end
end