module Campa
  module Core
    class PrintLn
      def call(*stuff, env:)
        out = env[SYMBOL_OUT] || $stdout
        stuff.each { |s| out.puts printer.call(s) }
        nil
      end

      private

      def printer
        @printer ||= Printer.new
      end
    end
  end
end
