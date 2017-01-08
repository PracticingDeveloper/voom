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

    def initialize(mem, addr)
      @data = mem.read_struct(addr, self.class.fields)

      @data.field_names.each do |e|
        define_singleton_method(e) { @data.send(e) }
        define_singleton_method("#{e}=") { |v| @data.send("#{e}=", v) }
      end
    end
  end
end