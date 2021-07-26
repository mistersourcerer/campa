module Campa
  module Lisp
    class Car
      def initialize
        @printer = Printer.new
      end

      def call(list)
        return nil if list.nil? || list == List::EMPTY
        raise illegal_argument(list) if !list.is_a?(List)

        list.head
      end

      private

      def illegal_argument(list)
        Error::IllegalArgument.new(@printer.call(list), "list")
      end
    end
  end
end
