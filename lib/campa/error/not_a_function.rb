module Campa
  module Error
    class NotAFunction < StandardError
      def initialize(label)
        super "The symbol: #{label} does not resolve to a function"
      end
    end
  end
end
