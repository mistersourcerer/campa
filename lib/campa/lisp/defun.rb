module Campa
  module Lisp
    class Defun
      PRINTER = Printer.new
      LABEL = Label.new

      def macro?
        true
      end

      def call(label, params, *body, env:)
        raise label_error(label) if !label.is_a?(Symbol)

        LABEL.call(label, invoke_lambda(params, body), env: env)
      end

      private

      def label_error(given)
        Error::IllegalArgument.new(PRINTER.call(given), "symbol")
      end

      def invoke_lambda(params, body)
        List.new(symbol("lambda"), params, *body)
      end
    end
  end
end
