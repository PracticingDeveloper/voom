require_relative "voom/memory"
require_relative "voom/memory_writer"
require_relative "voom/list"
require_relative "voom/type"
require_relative "voom/structure"

module Voom
  class << self
    attr_accessor :store
  end
end