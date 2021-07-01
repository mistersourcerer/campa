module Campa
  module Lisp
    class Label
      def initialize
        @evaler = Evaler.new
      end

      def macro?
        true
      end

      def call(label, expression, env:)
        env[label] = evaler.call(expression, env)
      end

      private

      attr_reader :evaler
    end
  end
end
