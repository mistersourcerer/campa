module Campa
  module Core
    # Searches functions with prefix test_ or test- (case insenstive)
    # in a given context, invoke those and
    # store their results in a Data Structure with the given form:
    #
    #   (
    #     (success, (test-one, test-two)),
    #     (failures, (test-three, test-four))
    #   )
    #
    # In this example we are considering that
    # functions <i>test-one</i> and <i>test-two</i> returned <b>true</b> and
    # functions <i>test-three</i> and <i>test-four</i> returned <b>false</b>.
    class Test
      def initialize
        @evaler = Campa::Evaler.new
      end

      # Execute functions named test-* or test_* (case insentive)
      # and collect the results.
      #
      # The param <i>tests</i> can be used to filter
      # specific tests to be executed.
      # For a context where functions
      # test-great-one, test-great-two and test-awful exists,
      # if we want to execute only the <i>great</i> ones, we could do:
      #
      # @example
      #   test = Test.new
      #   test.call("great", env: ctx)
      #
      # @param tests [Array<String>] if given will be used to "filter"
      #   functions by name
      # @param env [Context] will be used to search functions
      #   named test-* or test_* (case insentive) and also
      #   to execute those functions
      def call(*tests, env:)
        summary = execute_all(tests, env)
        List.new(
          List.new(Symbol.new("success"), List.new(*summary[:success])),
          List.new(Symbol.new("failures"), List.new(*summary[:failures]))
        )
      end

      private

      TEST_REGEXP = /\Atest(_|-)(.+)$/i

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
