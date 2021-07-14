module Campa
  module Lisp
    class LambdaFn
      def initialize
        @printer = Printer.new
      end

      def macro?
        true
      end

      def call(params, *body, env:)
        raise parameters_error(printer.call(params)) if !params.respond_to?(:find)

        invalid_param = params.find { |el| !el.is_a?(Symbol) }
        raise parameters_error(invalid_param, "symbol") if !invalid_param.nil?

        Lambda.new(params, body, env)
      end

      private

      attr_reader :printer

      def parameters_error(param, expected = "list of symbols")
        Error::Parameters.new(param, expected)
      end
    end
  end
end
