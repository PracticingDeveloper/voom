require "fiddle"

class String
  def alignment_pad
    Fiddle::ALIGN_INT - (self.length % Fiddle::ALIGN_INT)
  end

  def aligned_length
    self.length + self.alignment_pad
  end
end

module Fiddle
  SIGNED_INT_PATTERN = "l<"
  DOUBLE_FLOAT_PATTERN = "d"

  class Pointer
    def write_int(int)
      self[0, Fiddle::SIZEOF_INT] = [int].pack(SIGNED_INT_PATTERN)
      self + 0 + Fiddle::SIZEOF_INT
    end

    def read_int
      self[0, Fiddle::SIZEOF_INT].unpack(SIGNED_INT_PATTERN).first
    end

    def write_str(str)
      address = write_int(str.length)
      address[0, str.length] = str
      if (misalign = str.alignment_pad) != 0
        address[str.length, misalign] = 0.chr * misalign
      end
      address + str.length + misalign
    end

    def read_str
      size = read_int
      self[Fiddle::SIZEOF_INT, size]
    end

    def write_float(float)
      self[0, Fiddle::SIZEOF_DOUBLE] = [float].pack(DOUBLE_FLOAT_PATTERN)
      self + Fiddle::SIZEOF_DOUBLE
    end

    def read_float
      self[0, Fiddle::SIZEOF_DOUBLE].unpack(DOUBLE_FLOAT_PATTERN).first
    end
  end
end