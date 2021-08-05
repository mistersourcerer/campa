module Campa
  # Represents a storage for all bindings
  # in any <i>Campa</i> execution.
  #
  # All functions run inside their own context
  # so when they are finished
  # any binding created by it will be gone.
  #
  # The {Repl} also uses it's own {Context} for execution.
  class Context
    # @!visibility private
    attr_accessor :fallback

    # @param env [#[], #[]=] a Hash like or another {Context} object
    #   to be used as the underlying storage for this {Context}.
    def initialize(env = {})
      @env = env
    end

    # Creates a new binding between a given {Symbol} and an Object.
    #
    # @param symbol [Symbol]
    #   (actually, nothing guarantees it will be a symbol right now)
    #   to be bound to a value in this {Context}.
    # @param value [Object] associated to a given {Symbol}
    def []=(symbol, value)
      env[symbol] = value
    end

    # Returns the value bound to a {Symbol}
    #
    # @param symbol [Symbol] for which we want to fetch the value
    #   in this {Context}
    # @return Object
    def [](symbol)
      return env[symbol] if env.include?(symbol)

      fallback[symbol] if !fallback.nil?
    end

    # Check if there is any binding for a {Symbol}
    #
    # @param symbol [Symbol] "label" for a (possibly) bound value
    def include?(symbol)
      env.include?(symbol) ||
        (!fallback.nil? && fallback.include?(symbol))
    end

    # Creates a new {Context} assigning self as a #fallback to it.
    #
    # This means that if a {Symbol}
    # is not present on the returned {Context},
    # it will be searched on this one.
    # Which allows for building some sort of stack of {Context}s.
    #
    # WARNING: The name <i>push</i> on this API is very questionable,
    # I would like to change this to a visually more telling API.
    #
    # @param new_env [#[], #[]=] a Hash like or a {Context}
    #   that will serve as a fallback.
    # @return {Context}
    def push(new_env = {})
      # Context is explicit here instead of self.class.new
      # because we can inherit a context
      # like the Lisp::Core does.
      # In this case we want a normal context when pushing to it
      # (and not a Lisp::Core).
      Context.new(new_env).tap { |c| c.fallback = self }
    end

    # Return the current bindings in an Array.
    #
    # @example A simple {Context} with two bound {Symbol}
    #   ctx = Context.new(
    #     Symbol.new("lol") => "what time is it?",
    #     Symbol.new("bbq") => 420,
    #   )
    #   ctx.bindings #=> [
    #     [Symbol.new("lol"), "what time is it?"],
    #     [Symbol.new("bbq"), 420]
    #   ]
    def bindings
      @bindings ||= env.is_a?(Context) ? env.bindings : env.to_a
    end

    private

    attr_reader :env
  end
end
