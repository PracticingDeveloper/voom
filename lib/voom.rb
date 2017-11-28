require_relative "voom/memory"
require_relative "voom/memory_writer"
require_relative "voom/list"
require_relative "voom/type"
require_relative "voom/structure"

module Voom
  WORD_SIZE = 4
  NULL = 0

  class << self
    attr_accessor :store

    def hex(array)
      array.map { |e| '%.2x' % e }.join(" ")
    end
  end
end