module Campa
  module Core
    class PrintLn
      def call(*stuff, env:)
        out = env[SYMBOL_OUT] || $stdout
        stuff.each { |s| out.puts(s.is_a?(String) ? s : printer.call(s)) }
        nil
      end

      private

      def printer
        @printer ||= Printer.new
      end
    end
  end
end
