module Campa
  module Lisp
    class Quote
      def macro?
        true
      end

      def call(expression, _)
        expression
      end
    end
  end
end
