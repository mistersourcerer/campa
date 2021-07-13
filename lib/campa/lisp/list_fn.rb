module Campa
  module Lisp
    class ListFn
      def call(*items)
        List.new(*items)
      end
    end
  end
end
