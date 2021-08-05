module Campa
  # A node containing a value to form a linked {List}.
  class Node
    attr_accessor :next_node
    attr_reader :value

    # @param value [Object] actual value in the {List} node
    # @param next_node [Node] next node linked in the {List} chain,
    #   this {Node} is the last if <i>next_node:</i> is <i>nil</i>
    def initialize(value:, next_node: nil)
      @value = value
      @next_node = next_node
    end

    # @param other [Node] to be compared
    # @return [Boolean] <b>true</b> if {#value} is <i>#==</i> on both {Node}
    def ==(other)
      return false if !other.is_a?(Node)

      value == other.value
    end
  end
end
