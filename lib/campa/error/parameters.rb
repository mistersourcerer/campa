module Campa
  module Error
    class Parameters < ExecutionError
      def initialize(given, expected_type)
        msg = "Parameter list may only contain #{expected_type}: "
        msg += "#{given} is not a #{expected_type}."
        super(msg)
      end
    end
  end
end
