module Voom
  class Type
    def self.fields
      @fields ||= []
    end

    def self.str(name)
      fields << [name, :str]
    end

    def self.float(name)
      fields << [name, :float]
    end

    def self.int(name)
      fields << [name, :int]
    end

    def self.reference(name, target_class)
      fields << [name, target_class]
    end

    def self.list(name, target_class)
      fields << [name, ListReference.new(target_class)]
    end

    def self.write(mem=Voom.store, params)
      mem.write_struct(self, params)
    end

    def self.create(mem=Voom.store, params)
      new(mem, write(params))
    end

    def self.update(mem=Voom.store, ref, params)
      obj = new(mem, ref)

      params.each do |k,v|
        obj.send("#{k}=", v)
      end

      obj
    end
      
    def initialize(mem, addr)
      @mem  = mem

      @data = mem.read_struct(addr, self.class.fields)

      @data.field_names.each do |e|
        define_singleton_method(e) { @data.send(e) }
        define_singleton_method("#{e}=") { |v| @data.send("#{e}=", v) }
      end
    end
  end
end