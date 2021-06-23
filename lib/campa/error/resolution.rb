module Campa
  module Error
    class Resolution < ExecutionError
      def initialize(label)
        super "Unable to resolve symbol: #{label} in this context"
      end
    end
  end
end
