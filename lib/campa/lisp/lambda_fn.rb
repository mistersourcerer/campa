module Campa
  module Lisp
    class LambdaFn
      def macro?
        true
      end

      def call(params, *body, env:)
        invalid_param = params.find { |el| !el.is_a?(Symbol) }
        raise parameters_error(invalid_param) if !invalid_param.nil?

        Lambda.new(params, body, env)
      end

      private

      def parameters_error(param)
        Error::Parameters.new(param, "symbol")
      end
    end
  end
end
