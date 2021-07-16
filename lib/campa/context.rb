module Campa
  class Context
    attr_accessor :fallback

    def initialize(env = {})
      @env = env
    end

    def []=(symbol, value)
      env[symbol] = value
    end

    def [](symbol)
      return env[symbol] if env.include?(symbol)

      fallback[symbol] if !fallback.nil?
    end

    def include?(symbol)
      env.include?(symbol) ||
        (!fallback.nil? && fallback.include?(symbol))
    end

    def push(new_env = {})
      # Context is explicit here
      # (instead of self.class.new)
      # because we can inherit a context,
      # like the Lisp::Core does
      # and then we want a normal context when pushing to it
      # (and not a Lisp::Core).
      Context.new(new_env).tap { |c| c.fallback = self }
    end

    def bindings
      @bindings ||= env.is_a?(Context) ? env.bindings : env.to_a
    end

    private

    attr_reader :env
  end
end
