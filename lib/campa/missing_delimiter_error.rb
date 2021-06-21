module Campa
  class MissingDelimiterError < StandardError
    def initialize(delimiter)
      super "#{delimiter} was expected but none was found"
    end
  end
end
