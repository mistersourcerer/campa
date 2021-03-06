module Campa
  module Lisp
    class Atom
      def call(expression)
        case expression
        when Symbol, Numeric, TrueClass, FalseClass, String
          true
        when List
          expression == List::EMPTY
        end
      end
    end
  end
end
