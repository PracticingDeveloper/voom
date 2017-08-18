module Voom
  class FancyMemoryWriter
    VALUE_SPACE_OFFSET = 0x1000

    def initialize(mem)
      @mem = mem
      @r_pos = 0
      @v_pos = VALUE_SPACE_OFFSET

      @ref
    end

    attr_reader :v_pos

    def pos
      v_pos
    end

    def write_ptr(value)
      @mem.write_int(@r_pos, value)

      post_increment(Voom::WORD_SIZE, :r_pos)
    end

    def read_ptr(addr, type)
      @mem.read_ptr(addr, type)
    end

    def write_int(value)
      @mem.write_int(@v_pos, value)

      post_increment(Voom::WORD_SIZE, :v_pos)
    end

    def write_str(value)
      @mem.write_str(@v_pos, value)

      post_increment(Voom::WORD_SIZE + value.length, :v_pos)
    end

    def write_int!(value)
      addr = write_int(value)

      write_ptr(value)
    end

    def write_str!(value)
      addr = write_str(value)

      write_ptr(addr)
    end

    def write_float!(value)
      addr = write_float(value)

      write_ptr(addr)
    end

    def write_float(value)
      @mem.write_float(@v_pos, value)

      post_increment(Voom::WORD_SIZE * 2, :v_pos)
    end

    def write_list(type, data_pointers)
      @mem.write_list(@v_pos, type, data_pointers)

      post_increment(Voom::WORD_SIZE*2*data_pointers.length, :v_pos)
    end

    def seek(pos)
      @v_pos = pos
    end

    private

    # updates @pos, returns original
    def post_increment(offset, var)
      start_pos = instance_variable_get("@#{var}")
      instance_variable_set("@#{var}", start_pos + offset)

      start_pos
    end
  end
end


