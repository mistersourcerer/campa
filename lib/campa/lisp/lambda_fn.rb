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

        validate_params(params)
        Lambda.new(params, body, env)
      end

      private

      attr_reader :printer

      def parameters_error(param, expected = "list of symbols")
        Error::Parameters.new(param, expected)
      end

      def validate_params(params)
        invalid_param = params.find { |el| !el.is_a?(Symbol) }
        raise parameters_error(invalid_param, "symbol") if !invalid_param.nil?
      end
    end
  end
end
