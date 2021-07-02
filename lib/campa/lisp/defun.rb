module Campa
  module Lisp
    class Defun
      def initialize
        @printer = Printer.new
        @label_fn = Label.new
      end

      def macro?
        true
      end

      def call(label, params, *body, env:)
        raise label_error(label) if !label.is_a?(Symbol)

        label_fn.call(label, invoke_lambda(params, body), env: env)
      end

      private

      attr_reader :printer, :label_fn

      def label_error(given)
        Error::IllegalArgument.new(printer.call(given), "symbol")
      end

      def invoke_lambda(params, body)
        List.new(symbol("lambda"), params, *body)
      end
    end
  end
end
