module Campa
  module Lisp
    class Core < Context
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

      def initialize
        super Hash[
          CORE_FUNCS_MAP.map { |label, handler| [sym(label), handler.new] }
        ]
      end

      private

      def sym(label)
        Campa::Symbol.new(label)
      end
    end
  end
end
