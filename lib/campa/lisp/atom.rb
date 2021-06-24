module Campa
  module Lisp
    class Atom
      def call(expression, _)
        case expression
        when Symbol, Numeric, TrueClass, FalseClass, String
          true
        when List
          expression == List::EMPTY
        else
          false
        end
      end
    end
  end
end
