module Campa
  module Error
    class MissingDelimiter < StandardError
      def initialize(delimiter)
        super "#{delimiter} was expected but none was found"
      end
    end
  end
end
