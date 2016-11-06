require "fiddle"

module Fiddle
  FIXNUM_PATTERN = "l<"
  FLOAT_PATTERN = "d"
  POINTER_PATTERN = "q!"

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
      when :pointer
        Fiddle::Pointer.new(self[0, Fiddle::ALIGN_LONG_LONG].unpack(POINTER_PATTERN).first)
      when :string
        self[Fiddle::ALIGN_INT, read]
      when :unmarshal
        Marshal.load(self[Fiddle::ALIGN_INT, read])
      end
    end

	  def write(value)
      str = Pointer::format(value)
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

    def self.format(value)
      begin
        send(value.class.name.downcase.gsub("::", "__"), value)
      rescue NoMethodError
        string(Marshal.dump(value))
      end
    end

    def self.string(str)
      fixnum(str.length) + align(str)
    end

    def self.fixnum(int)
      [int].pack(FIXNUM_PATTERN)
    end

    def self.float(float)
      [float].pack(FLOAT_PATTERN)
    end

    def self.fiddle__pointer(ptr)
      [ptr].pack(POINTER_PATTERN)
    end
  end
end