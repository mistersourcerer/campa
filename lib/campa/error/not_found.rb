module Campa
  module Error
    class NotFound < ExecutionError
      def initialize(path)
        super "Can't find a file at: #{path}"
      end
    end
  end
end
