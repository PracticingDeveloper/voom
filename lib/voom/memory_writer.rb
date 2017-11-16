module Voom
  class MemoryWriter
    VALUE_SPACE_OFFSET = 0x1000

    def initialize
      @internal = Voom::Memory.new
      @r_pos = 0
      @v_pos = VALUE_SPACE_OFFSET

      # SET A NULL POINTER AT LOCATION 0
      write_ptr(write_int(Voom::NULL))
    end

    attr_reader :v_pos, :r_pos, :internal

    def pos
      v_pos
    end

    def read_struct(address, type)
      Voom::Structure.new(self, address, type)
    end

    def write_struct(type, values)
      pointers = []

      type.fields.each do |n,t|
        if (t.kind_of?(Class) && t.ancestors.include?(Voom::Type))

          pointers << write_ptr(values.fetch(n))
        elsif t.kind_of?(Voom::ListReference)
          pointers << write_list(*values.fetch(n))
        else
          pointers << send("write_#{t}!", values.fetch(n))
        end
      end

      pointers.first
    end

    def write_list(*refs)
      first, *middle, last = refs

      head_ref = write_int!(first)

      (middle + Array(last)).each do |e|
        write_int(pos + Voom::WORD_SIZE)
        write_int(e)
      end

      write_int(Voom::NULL)  

      head_ref
    end

    def write_ptr(value)
      @internal.write_int(@r_pos, value)

      post_increment(Voom::WORD_SIZE, :r_pos)
    end

    def read_ptr(address, type)
      if (type.kind_of?(Class) && type.ancestors.include?(Voom::Type)) || type.kind_of?(Voom::ListReference)
        type.new(self, read_int(address))
      else
        @internal.send("read_#{type}", read_int(address))
      end
    end

    def write_int(value)
      @internal.write_int(@v_pos, value)

      post_increment(Voom::WORD_SIZE, :v_pos)
    end

    def read_int(value)
      @internal.read_int(value)
    end

    def write_str(value)
      @internal.write_str(@v_pos, value)

      post_increment(Voom::WORD_SIZE + value.length, :v_pos)
    end

    def write_int!(value)
      addr = write_int(value)

      write_ptr(addr)
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
      @internal.write_float(@v_pos, value)

      post_increment(Voom::WORD_SIZE * 2, :v_pos)
    end

    def seek(pos)
      @v_pos = pos
    end

    def inspect
      @internal.inspect
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


