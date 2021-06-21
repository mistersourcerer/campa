module Campa
  module Error
    class Resolution < StandardError
      def initialize(label)
        "Unable to resolve symbol: #{label} in this context"
      end
    end
  end
end
