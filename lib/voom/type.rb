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