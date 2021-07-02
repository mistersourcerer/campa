module Campa
  module Lisp
    class Label
      def initialize
        @evaler = Evaler.new
        @printer = Printer.new
      end

      def macro?
        true
      end

      def call(label, expression, env:)
        result = evaler.call(expression, env)
        raise Error::Reserved, printer.call(label) if reserved?(label, result)

        env[label] = result
      end

      private

      attr_reader :evaler, :printer

      def reserved?(symbol, result)
        symbol.label.match?(CR_REGEX) && result.is_a?(Lambda)
      end
    end
  end
end
