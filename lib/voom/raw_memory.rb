require "fiddle"

module Fiddle
  FIXNUM_PATTERN = "l<"
  FLOAT_PATTERN = "d"

  class BufferOverflow < IndexError
  	attr_reader :address, :request
    def initialize(address, request)
      @address = address
      @request = request
      super("Buffer overflow: requested #{request} bytes at #{address.inspect}")
    end
  end

  class Pointer
    def read(type=:fixnum)
      case type
      when :fixnum
        self[0, Fiddle::ALIGN_INT].unpack(FIXNUM_PATTERN).first
      when :float
        self[0, Fiddle::ALIGN_DOUBLE].unpack(FLOAT_PATTERN).first
      when :string
        self[Fiddle::ALIGN_INT, read]
      end
    end

	  def write(value)
      str = case value
      when Fixnum
        Pointer::fixnum(value)
      when Float
        Pointer::float(value)
      when String
        Pointer::pstring(value)
      else
        Pointer::pstring(value.respond_to?(:to_mem) ? value.memory : Marshal.dump(value))
      end

      raise BufferOverflow.new(self, str.length) if str.length > size
      self[0, str.length] = str
      self + str.length
	  end

    def self.align(str)
      padding = str.length % Fiddle::ALIGN_INT
      if padding > 0
        padding = Fiddle::ALIGN_INT - padding
      end
      str += 0.chr * padding
    end

    def self.pstring(str)
      Pointer::align(Pointer::fixnum(str.length) + str)
    end

    def self.fixnum(int)
      [int].pack(FIXNUM_PATTERN)
    end

    def self.float(float)
      [float].pack(FLOAT_PATTERN)
    end
  end
end