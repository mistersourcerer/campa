module Campa
  class Evaler
    def call(expression, env = {})
      context = self.context(env)

      case expression
      when Numeric, TrueClass, FalseClass, NilClass, String, ::Symbol
        expression
      when Symbol
        resolve(expression, context)
      when List
        return List::EMPTY if expression == List::EMPTY

        invoke(expression, context)
      end
    end

    private

    def context(env)
      return env if env.is_a?(Context)

      Context.new(env)
    end

    def resolve(symbol, context)
      raise Error::Resolution, symbol.label if !context.include?(symbol)

      context[symbol]
    end

    def invoke(invocation, context)
      fn = resolve(invocation.head, context)
      raise Error::NotAFunction, invocation.head if !fn.respond_to?(:call)

      args =
        args_for_fun(fn, invocation.tail.to_a, context)
        .append(context.push(Context.new))
      fn.call(*args)
    end

    def args_for_fun(fun, args, context)
      if fun.respond_to?(:macro?) && fun.macro?
        args
      else
        args.map { |exp| call(exp, context) }
      end
    end
  end
end
