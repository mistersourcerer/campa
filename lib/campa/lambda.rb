module Campa
  class Lambda
    EVALER = Evaler.new

    attr_reader :params, :body, :closure

    def initialize(params, body, closure = Context.new)
      @params = params
      @body = body
      @closure = closure
    end

    def call(*args, env:)
      raise arity_error(args) if params.to_a.length != args.length

      ivk_env = invocation_env(env, args)
      @body.reduce(nil) { |_, expression| EVALER.call(expression, ivk_env) }
    end

    def ==(other)
      return false if !other.is_a?(Campa::Lambda)

      params == other.params && body == other.body
    end

    private

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
