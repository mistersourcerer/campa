module Campa
  class Evaler
    def call(expression, env = {})
      case expression
      when Numeric, TrueClass, FalseClass, NilClass, String, ::Symbol
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
      fn = resolve(invocation.head, env)
      not_a_function_error(invocation.head) if !fn.respond_to?(:call)
      fn.call(*invocation.tail)
    end

    def not_a_function_error(symbol)
      raise(NotAFunctionError,
            "The symbol: #{symbol.label} does not resolve to a function")
    end
  end
end
