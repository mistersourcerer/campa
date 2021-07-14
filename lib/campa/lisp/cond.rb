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

      def call(*conditions, env:)
        found = conditions.find do |cond|
          raise illegal_argument(cond) if !cond.is_a?(List)

          !FALSEY.include? evaler.call(cond.head, env)
        end

        eval_result(found, env)
      end

      private

      attr_reader :evaler, :printer

      def illegal_argument(thing)
        Error::IllegalArgument.new(printer.call(thing), "list")
      end

      def eval_result(found, env)
        return if found.nil?

        # For when condition is a "truethy" value
        #
        # (cond
        #   ((eq 1 2) 'no)
        #   (true 'yes)
        # )
        # => 'yes
        to_eval = found.tail == List::EMPTY ? found.head : found.tail.head
        evaler.call(to_eval, env)
      end
    end
  end
end
