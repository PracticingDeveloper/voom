module Voom
  class ListReference
    def initialize(type)
      @type = type
    end

    def new(memory, addr)
      List.new(@type, memory, addr)
    end
  end

  class List
    include Enumerable

    def initialize(type, memory, addr)
      @type        = type
      @memory      = memory
      @addr        = addr
    end

    def data
      @memory.read_ptr(@addr, @type)
    end

    def each
      node = self

      while node
        yield node.data
        
        node = node.next
      end
    end

    private

    def next_addr
      @memory.read_int(@addr + Voom::WORD_SIZE)
    end
  end
end