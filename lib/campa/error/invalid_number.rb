module Campa
  module Error
    class InvalidNumber < ExecutionError
      def initialize(fake_number)
        super("Invalid number: #{fake_number}")
      end
    end
  end
end
