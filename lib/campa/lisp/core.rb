module Campa
  module Lisp
    class Core < Context
      def initialize
        super({
          sym("quote") => Quote.new,
          sym("atom") => Atom.new,
          sym("eq") => Eq.new,
          sym("car") => Car.new,
          sym("cdr") => Cdr.new,
          sym("cons") => Cons.new,
        })
      end

      private

      def sym(label)
        Campa::Symbol.new(label)
      end
    end
  end
end
