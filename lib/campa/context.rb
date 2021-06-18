module Campa
  class Context
    def initialize(env = {})
      @env = env
    end

    def []=(symbol, value)
      env[symbol] = value
    end

    def [](symbol)
      return env[symbol] if env.include?(symbol)

      return fallback[symbol] if !fallback.nil?
    end

    def include?(symbol)
      env.include?(symbol) ||
        (!fallback.nil? && fallback.include?(symbol))
    end

    def push(new_env = {})
      self.class.new(new_env).tap { |c| c.fallback = self }
    end

    protected

    attr_accessor :fallback

    private

    attr_reader :env
  end
end
