module Campa
  module Lisp
    class Cadr
      def initialize
        @printer = Printer.new
        @car = Car.new
        @cdr = Cdr.new
      end

      def macro?
        true
      end

      def call(operation, list)
        raise illegal_argument(list) if !list.is_a?(List)

        operation.label[1..-2].reverse.split("").reduce(list) do |l, oper|
          if oper == "a"
            @car.call(l)
          else
            @cdr.call(l)
          end
        end
      end

      private

      def illegal_argument(list)
        Error::IllegalArgument.new(@printer.call(list), "list")
      end
    end
  end
end
