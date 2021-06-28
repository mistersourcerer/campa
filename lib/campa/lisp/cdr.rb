module Campa
  module Lisp
    class Cdr
      def initialize
        @printer = Printer.new
      end

      def call(list)
        raise illegal_argument(list) if !list.is_a?(List)

        list.tail
      end

      private

      def illegal_argument(list)
        Error::IllegalArgument.new(@printer.call(list), "list")
      end
    end
  end
end
