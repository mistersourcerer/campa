module Campa
  # Represents the name to which a value is bound in a specific {Context}.
  #
  # Implements the necessary interface to be used with success
  # as key in Hash objects.
  class Symbol
    attr_reader :label

    # @param label [String] name to be bound to a value in a given {Context}
    def initialize(label)
      @label = label
    end

    # @param other [Symbol] another {Symbol} to be compared
    # @return [Boolean] <b>true</b> if both {#label} are <i>#==</i>
    def ==(other)
      return false if !other.is_a?(self.class)

      label == other.label
    end

    # @param other [Symbol] another {Symbol} to be compared
    # @return [Boolean] <b>true</b> if both {Symbol} are <i>#==</i>
    #   and both {#hash} are <i>#==</i>
    def eql?(other)
      self == other && hash == other.hash
    end

    # @return [String] String based on <i>label#hash</i>.
    def hash
      @hash ||= "Campa::Symbol_#{label}".hash
    end
  end
end
