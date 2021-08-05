module Campa
  # Represents an anonymous function
  # that will be executed in a given {Context}.
  #
  # @example
  #   # given the representation of
  #   # ((lambda (something) (print something)) "hello world")
  #   lbd = Lambda.new(
  #     [Symbol.new("something")],
  #     [List.new(Symbol.new("print"), Symbol.new("something"))]
  #   )
  #
  #   # sends "hello world" to the $stdout and returns
  #   lbd.call("hello world") #=> nil
  #
  # @example working with closures:
  #
  #   # given the representation of
  #   # (label meaning 42)
  #   # ((lambda (time) (print "time: " time " meaning of life: " meaning)) 420)
  #   ctx = Context.new(Symbol.new("meaning") => 42)
  #
  #   lbd = Lambda.new(
  #     [Symbol.new("time")],
  #     [
  #       List.new(
  #         Symbol.new("print"),
  #         "time: ", Symbol.new("time"),
  #         ", meaning of life: ", Symbol.new("meaning")
  #       )
  #     ],
  #     ctx
  #   )
  #
  #   # sends "time: 420, meaning of life: 42" to $stdout and returns
  #   lbd.call(420) #=> nil
  class Lambda
    attr_reader :params, :body, :closure

    # @param params [Array<Symbol>] {Symbol}s naming the parameters
    #   that a lambda can receive when being invoked
    # @param body [Array<Object>] expressions composing the body,
    #   they are executed one by one in order
    #   in the given {Context}
    # @param closure [Context] used as a fallback for the {Context}
    #   given when the {Lambda} is executed
    def initialize(params, body, closure = Context.new)
      @params = params
      @body = Array(body)
      @closure = closure
      @evaler = Evaler.new
    end

    # Executes the expressions contained in the {#body}
    # one by one using as {Context} the parameter <i>env:</i>
    # on this method.
    #
    # The <i>env:</i> param will be used here
    # as a fallback to a brand new {Context}
    # created in the moment of the invocation.
    # This isolates the {Context} passed as a parameter
    # of any mutations that would be created
    # by the {Lambda} if there is any binding during the execution.
    #
    # @param args [Array<Object>] the values that will be bound
    #   to each of the {#params} given to the constructor
    # @param env [Context] for the execution of a lambda
    # @return [Object] result of evaluating the last expression on {#body}
    def call(*args, env:)
      raise arity_error(args) if params.to_a.length != args.length

      @body.reduce(nil) do |_, expression|
        evaler.call(
          expression,
          invocation_env(env, args)
        )
      end
    end

    # Stablishes equality between {Lambda} objects
    # by comparing {#params} and {#body}
    #
    # @param other [Lambda] another {Lambda}
    # @return [Boolean] <b>true</b> if {#params} names and {#body} expressions
    #   are <i>#==</i> in both {Lambda}.
    def ==(other)
      return false if !other.is_a?(Campa::Lambda)

      params == other.params && body == other.body
    end

    private

    attr_reader :evaler

    def arity_error(args)
      Error::Arity.new("lambda", params.to_a.length, args.length)
    end

    def invocation_env(env, args)
      closure.push(env.push(Context.new)).tap do |ivk_env|
        params.each_with_index do |symbol, idx|
          ivk_env[symbol] = args[idx]
        end
      end
    end
  end
end
