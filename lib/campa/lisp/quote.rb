module Campa
  module Lisp
    class Quote
      def macro?
        true
      end

      def call(expression)
        expression
      end
    end
  end
end
