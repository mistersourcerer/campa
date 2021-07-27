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
        return nil if list.nil? || list == List::EMPTY
        raise illegal_argument(list) if !list.is_a?(List)

        cut_list(
          list,
          operation
            .label[1..-2]
            .reverse
            .split("")
        )
      end

      private

      def illegal_argument(list)
        Error::IllegalArgument.new(@printer.call(list), "list")
      end

      def cut_list(list, invocation_sequence)
        invocation_sequence.reduce(list) do |l, oper|
          to_call = oper == "a" ? @car : @cdr
          to_call.call(l)
        end
      end
    end
  end
end
