module Voom
  class Structure
    def initialize(mem, addr, type)
      @mem     = mem
      @addr    = addr
      @type   = type
      @field_addrs = {}

      define_field_accessors
    end
  
    attr_reader :field_names

    private

    def define_field_accessors
      pos = @addr

      @type.each do |k,t|
        @field_addrs[k] = pos

        define_singleton_method(k) do
          @mem.read_ptr(@field_addrs[k], t)
        end

        define_singleton_method("#{k}=") do |v|
          raise NotImplementedError
        end

        pos += Voom::WORD_SIZE
      end

      @field_names = @field_addrs.keys
    end
  end
end
