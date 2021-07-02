module Campa
  module Error
    class Reserved < ExecutionError
      def initialize(label)
        super "Reserved function name: #{label} is already taken, sorry about that"
      end
    end
  end
end
