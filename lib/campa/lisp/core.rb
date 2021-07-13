module Campa
  module Lisp
    class Core < Context
      # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
      def initialize
        super({
          sym("quote") => Quote.new,
          sym("atom") => Atom.new,
          sym("eq") => Eq.new,
          sym("car") => Car.new,
          sym("cdr") => Cdr.new,
          sym("cons") => Cons.new,
          sym("cond") => Cond.new,
          sym("lambda") => LambdaFn.new,
          sym("label") => Label.new,
          sym("defun") => Defun.new,
          sym("_cadr") => Cadr.new,
          sym("list") => ListFn.new,
        }.freeze)
      end
      # rubocop: enable Metrics/MethodLength, Metrics/AbcSize

      private

      def sym(label)
        Campa::Symbol.new(label)
      end
    end
  end
end
