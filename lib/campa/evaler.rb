module Campa
  class Evaler
    def call(expression, env = {})
      case expression
      when Numeric, TrueClass, FalseClass, NilClass
        expression
      when Symbol
        resolve(expression, env)
      when List
        invoke(expression, env)
      end
    end

    private

    def resolve(symbol, env)
      resolution_error(symbol) if !env.include?(symbol)

      env[symbol]
    end

    def resolution_error(symbol)
      raise(ResolutionError,
            "Unable to resolve symbol: #{symbol.label} in this context")
    end

    def invoke(invocation, env)
      resolve(invocation.head, env).call(*invocation.tail)
    end
  end
end
