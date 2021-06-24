module Campa
  module Lisp
    class Core < Context
      def initialize
        super({
          sym("quote") => Quote.new,
          sym("atom") => Atom.new,
        })
      end

      private

      def sym(label)
        Campa::Symbol.new(label)
      end
    end
  end
end
