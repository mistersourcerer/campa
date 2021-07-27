module Campa
  module Error
    class Reserved < ExecutionError
      def initialize(label)
        msg = "Reserved function name: #{label} "
        msg += "is already taken, sorry about that"
        super msg
      end
    end
  end
end
