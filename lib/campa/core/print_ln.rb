module Campa
  module Core
    # <i>Campa</i> function that print "anything" to the $stdout.
    class PrintLn
      # It uses {Printer} to transform an Object
      # into a human readable form
      # and sends it to $stdout.
      #
      # Uses <i>#puts</i> method in the output to add a new line
      # after sending each String representation
      # created via {Printer} be sent to the output.
      #
      # It is possible to override the preference for using $stdout
      # by binding {SYMBOL_OUT} to a desired Object
      # in the env given as a parameter to this method.
      #
      # @param stuff [Object] anything resulting from evaling a <i>Campa</i> expression
      # @param env [Context] where {SYMBOL_OUT} will be searched
      #   to find an alternative to $stdout
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
