module Campa
  class Node
    attr_accessor :next_node
    attr_reader :value

    def initialize(value:, next_node: nil)
      @value = value
      @next_node = next_node
    end
  end
end
