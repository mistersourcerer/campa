module Campa
  class Evaler
    def initialize
      @printer = Printer.new
    end

    def call(expression, env = {})
      context = self.context(env)

      case expression
      when Numeric, TrueClass, FalseClass, NilClass, String, ::Symbol, List::EMPTY
        expression
      when Symbol
        resolve(expression, context)
      when List
        invoke(expression, context)
      end
    end

    def eval(reader, env = {})
      result = nil
      while (token = reader.next)
        result = call(token, env)
      end
      result
    end

    private

    attr_reader :printer

    def context(env)
      return env if env.is_a?(Context)

      Context.new(env)
    end

    def resolve(symbol, context)
      raise Error::Resolution, printer.call(symbol) if !context.include?(symbol)

      context[symbol]
    end

    def invoke(invocation, context)
      return invoke_cadr(invocation, context) if cr?(invocation)

      fn = extract_fun(invocation, context)
      args = args_for_fun(fn, invocation.tail.to_a, context)
      return fn.call(*args, env: context) if with_env?(fn)

      fn.call(*args)
    end

    def cr?(invocation)
      invocation.head.is_a?(Symbol) &&
        invocation.head.label.match?(CR_REGEX)
    end

    def invoke_cadr(invocation, context)
      call(
        List.new(
          Symbol.new("_cadr"),
          invocation.head,
          call(invocation.tail.head, context)
        ),
        context
      )
    end

    def extract_fun(invocation, context)
      # probable lambda invocation
      return call(invocation.head, context) if invocation.head.is_a?(List)

      resolve(invocation.head, context)
        .then { |rs| rs.is_a?(List) ? call(rs, context) : rs }
        .tap { |fn| raise not_a_function(invocation) if !fn.respond_to?(:call) }
    end

    def not_a_function(invocation)
      Error::NotAFunction.new printer.call(invocation.head)
    end

    def args_for_fun(fun, args, context)
      return args if fun.respond_to?(:macro?) && fun.macro?

      args.map { |exp| call(exp, context) }
    end

    def with_env?(fun)
      !params_from_fun(fun)
        .filter { |param| param[0] == :keyreq }
        .find { |param| param[1] == :env }
        .nil?
    end

    def params_from_fun(fun)
      return fun.parameters if fun.is_a?(Proc)

      fun.method(:call).parameters
    end
  end
end
