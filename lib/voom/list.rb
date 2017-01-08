module Voom
  class List
    include Enumerable

    def initialize(type, memory, addr)
      @type        = type
      @memory      = memory
      
      @data        = memory.read_ptr(addr, type)
      @next_addr   = memory.read_int(addr + Voom::WORD_SIZE)
    end

    attr_reader :data

    def next
      return nil if @next_addr.zero? 

      List.new(@type, @memory, @next_addr)
    end

    def each
      node = self

      while node
        yield node.data
        
        node = node.next
      end
    end
  end
end