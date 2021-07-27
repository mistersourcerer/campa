module Campa
  module Core
    class Test
      TEST_REGEXP = /\Atest(_|-)(.+)$/i

      def initialize
        @evaler = Campa::Evaler.new
      end

      def call(*tests, env:)
        summary = execute_all(tests, env)
        List.new(
          List.new(Symbol.new("success"), List.new(*summary[:success])),
          List.new(Symbol.new("failures"), List.new(*summary[:failures]))
        )
      end

      private

      attr_reader :evaler

      def execute_all(tests, env)
        { success: [], failures: [] }.tap do |summary|
          env
            .bindings
            .select { |(sym, object)| test_func?(sym, object) }
            .select { |(sym, _)| included?(tests, sym) }
            .each { |(sym, fn)| add_to_summary(summary, sym, fn, env) }
        end
      end

      def test_func?(sym, object)
        TEST_REGEXP.match?(sym.label) && object.respond_to?(:call)
      end

      def included?(tests, sym)
        tests.empty? || tests.include?(TEST_REGEXP.match(sym.label)[2])
      end

      def add_to_summary(summary, sym, func, env)
        type = safely_execute(func, env) ? :success : :failures
        summary[type] << sym
      end

      def safely_execute(func, env)
        func.call(env: env)
      rescue StandardError
        false
      end
    end
  end
end
