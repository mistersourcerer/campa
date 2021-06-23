module Campa
  module Error
    class MissingDelimiter < ExecutionError
      def initialize(delimiter)
        super "#{delimiter} was expected but none was found"
      end
    end
  end
end
