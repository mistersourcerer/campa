module Campa
  module Lisp
    # {Context} representing the base for the minimal Lisp
    # stablished by <i>Paul Graham's: <b>The Roots of Lisp</b></i>.
    #
    # Since this is a {Context}
    # it can be instantiated and use as a parameter
    # to any function invocation that
    # want's to use <i>Lisp</i> functions on it's body.
    # And also, it can be used as a fallback
    # so if we want to "extend" <i>Lisp</i>
    # we could Inherit it or {#push} a new {Context} on it.
    class Core < Context
      def initialize
        super Hash[
          CORE_FUNCS_MAP.map { |label, handler| [sym(label), handler.new] }
        ]
      end

      private

      CORE_FUNCS_MAP = {
        "quote" => Quote,
        "atom" => Atom,
        "eq" => Eq,
        "car" => Car,
        "cdr" => Cdr,
        "cons" => Cons,
        "cond" => Cond,
        "lambda" => LambdaFn,
        "label" => Label,
        "defun" => Defun,

        "_cadr" => Cadr,
        "list" => ListFn,

        "load" => Campa::Core::Load,
      }.freeze

      def sym(label)
        Campa::Symbol.new(label)
      end
    end
  end
end
