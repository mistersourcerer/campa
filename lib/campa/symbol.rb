module Campa
  class Symbol
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def ==(other)
      return false if !other.is_a?(self.class)

      label == other.label
    end

    def eql?(other)
      self == other && hash == other.hash
    end

    def hash
      @hash ||= "Campa::Symbol_#{label}".hash
    end
  end
end
