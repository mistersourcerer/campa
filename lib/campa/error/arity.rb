module Campa
  module Error
    class Arity < ExecutionError
      def initialize(fun, expected, given)
        msg = "Arity error when invoking #{fun}: "
        msg += "expected #{expected} arg(s) but #{given} given"
        super msg
      end
    end
  end
end
