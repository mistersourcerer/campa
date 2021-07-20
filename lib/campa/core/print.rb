module Campa
  module Core
    class Print
      SYMBOL_OUT = Symbol.new("__out__")

      def call(*stuff, env:)
        string = stuff.map { |s| printer.call(s) }
                      .join(" ")
        (env[SYMBOL_OUT] || $stdout).print(string)
        nil
      end

      private

      def printer
        @printer ||= Printer.new
      end
    end
  end
end
