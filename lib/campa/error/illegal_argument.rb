module Campa
  module Error
    class IllegalArgument < ExecutionError
      def initialize(given, expected)
        super "Illegal argument: #{given} was expected to be a #{expected}"
      end
    end
  end
end
