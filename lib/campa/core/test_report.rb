module Campa
  module Core
    class TestReport
      def call(result, env:)
        success, failures = %i[success failures].map { |t| filter(t, result) }
        out = env[SYMBOL_OUT] || $stdout
        show_summary(success, failures, out)
      end

      private

      def show_summary(success, failures, out)
        out.puts "\n\n#{success.length + failures.length} tests ran"

        if failures.empty?
          success_summary(success, out)
        else
          failure_summary(failures, out)
        end
      end

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
        [
          "FAIL!",
          "  #{failures.length} tests failed",
          "  they are:",
        ].each { |str| out.puts str }

        failures.each { |t| out.puts "    - #{t}" }

        false
      end
    end
  end
end
