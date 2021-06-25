module Campa
  module Lisp
    class Eq
      def initialize
        @evaler = Evaler.new
      end

      def call(*args)
        case args
        in expr_a, expr_b, _, *_
          expr_a == expr_b
        else
          raise "args wrongs!"
        end
      end
    end
  end
end
