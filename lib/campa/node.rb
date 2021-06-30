module Campa
  class Node
    attr_accessor :next_node
    attr_reader :value

    def initialize(value:, next_node: nil)
      @value = value
      @next_node = next_node
    end

    def ==(other)
      return false if !other.is_a?(Node)

      value == other.value
    end
  end
end
