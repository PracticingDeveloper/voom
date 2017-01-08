module Voom
  #TODO: Lists should be read directly from memory, like other primitive types
  # and then wrapped in a higher level object. I.e. this is what will e
  # returned by mem.read_list(address)
  
  class List
    def initialize(type, memory, data_ptr)
      @type      = type
      @memory    = memory
      @data_ptr  = data_ptr
      @next      = nil
    end

    def data  
      @memory.send(:read_ptr, @data_ptr, @type)
    end

    def next
      @next
    end

    def link(next_ptr)
      @next = List.new(@type, @memory, next_ptr)
    end
  end
end