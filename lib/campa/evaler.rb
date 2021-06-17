module Campa
  class Evaler
    def call(expression)
      case expression
      when Numeric, TrueClass, FalseClass, NilClass
        expression
      end
    end
  end
end
