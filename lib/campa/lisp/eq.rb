module Campa
  module Lisp
    class Eq
      def call(expr_a, expr_b)
        expr_a == expr_b
      end
    end
  end
end
