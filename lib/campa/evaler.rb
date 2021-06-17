module Campa
  class Evaler
    def call(expression, env = {})
      case expression
      when Numeric, TrueClass, FalseClass, NilClass
        expression
      when Symbol
        resolve(expression, env)
      end
    end

    private

    def resolve(symbol, env)
      env[symbol]
    end
  end
end
