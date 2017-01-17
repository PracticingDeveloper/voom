module Voom
  class MemoryWriter
    def initialize(mem)
      @mem = mem
      @pos = 0
    end

    attr_reader :pos

    def write_int(value)
      @mem.write_int(@pos, value)

      post_increment(Voom::WORD_SIZE)
    end

    def write_str(value)
      @mem.write_str(@pos, value)

      post_increment(Voom::WORD_SIZE + value.length)
    end

    def write_float(value)
      @mem.write_float(@pos, value)

      post_increment(Voom::WORD_SIZE * 2)
    end

    def write_list(type, data_pointers)
      @mem.write_list(@pos, type, data_pointers)

      post_increment(Voom::WORD_SIZE*2*data_pointers.length)
    end

    def seek(pos)
      @pos = pos
    end

    private

    # updates @pos, returns original
    def post_increment(offset)
      start_pos = @pos
      @pos += offset
      start_pos
    end
  end
end


