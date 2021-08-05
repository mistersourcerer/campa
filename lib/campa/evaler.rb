module Campa
  # All the actual logic on how to evaluate
  # the differente known forms
  # in implemented in here.
  class Evaler
    def initialize
      @printer = Printer.new
    end

    # Returns the result of a given form evaluation.
    #
    # The parameter expression is evaluated
    # based on it's type.
    # Primitives (like booleans, nil, strings...) are returned as is.
    # {Symbol}s and {List}s are handled like this:
    # - {Symbol}'s are searched in the given {Context} (env parameter).
    # - {List}'s are considered function invocations.
    #
    # @param expression Can be any known form.
    # @param env [#[], #[]=] Hash or {Context} containing the bindings
    #   for the current <i>Campa</i> execution.
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

    # Receives a {Reader} object
    # and evaluate all forms returned
    # by each <i>#next</i> call.
    # Uses {#call} to do the actual evaluation.
    #
    # @param reader [Reader] representing the source code to be evaluated
    # @param env [Context] to evaluate the code
    # @return [Object] the result of evaluating the last form
    #   available in the given {Reader}
    def eval(reader, env = {})
      context = self.context(env)

      result = nil
      while (token = reader.next)
        result = call(token, context)
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
      if with_env?(fn)
        fn.call(*args, env: context)
      else
        fn.call(*args)
      end
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
