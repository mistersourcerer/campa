module Campa
  module Error
    class InvalidNumber < StandardError
      def initialize(fake_number)
        super("Invalid number: #{fake_number}")
      end
    end
  end
end
