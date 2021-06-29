module Campa
  module Lisp
    class Cond
      FALSEY = [false, nil].freeze

      def initialize
        @printer = Printer.new
        @evaler = Evaler.new
      end

      def macro?
        true
      end

      def call(conditions, env:)
        raise illegal_argument(conditions) if !conditions.is_a?(List)

        found = conditions.find do |cond|
          # raise if cond is not a list
          !FALSEY.include? @evaler.call(cond.head, env)
        end
        eval_result(found, env)
      end

      private

      def illegal_argument(thing)
        Error::IllegalArgument.new(@printer.call(thing), "list")
      end

      def eval_result(found, env)
        return if found.nil?

        to_eval =
          if found.tail == List::EMPTY
            found.head
          else
            found.tail.head
          end

        @evaler.call(to_eval, env)
      end
    end
  end
end
