module Campa
  module Core
    class TestReport
      def call(result, env:)
        success = filter(:success, result)
        failures = filter(:failures, result)
        tests_ran = success.length + failures.length
        out = env[Symbol.new("__out__")] || $stdout
        out.puts "\n\n#{tests_ran} tests ran"
        return success_summary(success, out) if failures.empty?

        failure_summary(failures, out)
      end

      private

      def filter(type, result)
        filtered =
          result
          .to_a
          .find { |l| l.head == Symbol.new(type.to_s) }
        return [] if filtered.nil?

        label_only(filtered)
      end

      def label_only(filtered)
        filtered
          .tail
          .head
          .to_a
          .map(&:label)
      end

      def success_summary(_success, out)
        out.puts "Success: none of those returned false"

        true
      end

      def failure_summary(failures, out)
        out.puts "FAIL!"
        out.puts "  #{failures.length} tests failed"
        out.puts "  they are:"
        failures.each { |t| out.puts "    - #{t}" }

        false
      end
    end
  end
end
