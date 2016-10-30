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
    def write_int(address, int)
      self[address, Fiddle::SIZEOF_INT] = [int].pack(SIGNED_INT_PATTERN)
    end

    def read_int(address)
      self[address, Fiddle::SIZEOF_INT].unpack(SIGNED_INT_PATTERN).first
    end

    def write_str(address, str)
      write_int(address, str.length)
      address += Fiddle::SIZEOF_INT
      self[address, str.length] = str
      if (misalign = str.alignment_pad) != 0
        self[address + str.length, misalign] = 0.chr * misalign
      end
    end

    def read_str(address)
      size = read_int(address)
      self[address + Fiddle::SIZEOF_INT, size]
    end

    def write_float(address, float)
      self[address, Fiddle::SIZEOF_DOUBLE] = [float].pack(DOUBLE_FLOAT_PATTERN)
    end

    def read_float(address)
      self[address, Fiddle::SIZEOF_DOUBLE].unpack(DOUBLE_FLOAT_PATTERN).first
    end

    private
    def debug_print address
      caller = caller_locations(1,1)[0].label
      puts "#{caller}: base address = #{self.to_i}"
      puts "#{caller}: address = #{address}"
      puts "#{caller}: length = #{WORD_SIZE}"
      puts "#{caller}: self[] = #{self[address, WORD_SIZE]}"
    end
  end
end