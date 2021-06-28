module Campa
  module Lisp
    class Cons
      def initialize
        @printer = Printer.new
      end

      def call(new_head, list)
        raise illegal_argument(list) if !list.is_a?(List)

        list.push(new_head)
      end

      private

      def illegal_argument(list)
        Error::IllegalArgument.new(@printer.call(list), "list")
      end
    end
  end
end
