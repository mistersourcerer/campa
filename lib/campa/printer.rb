module Campa
  class Printer
    FORMATS = {
      String => :string,
      Symbol => :symbol,
      List => :list,
      TrueClass => :boolean,
      FalseClass => :boolean,
      Lambda => :lambda,
      Context => :context,
      NilClass => :null,
    }.freeze

    def call(expr)
      format = FORMATS.fetch(expr.class) do
        expr.is_a?(Context) ? :context : :default
      end
      send(format, expr)
    end

    private

    SYM_LAMBDA = Symbol.new("lambda")

    def string(expr)
      "\"#{expr}\""
    end

    def symbol(expr)
      expr.label
    end

    def list(expr)
      "(#{expr.map { |el| call(el) }.join(" ")})"
    end

    def boolean(expr)
      (expr == true).to_s
    end

    def lambda(expr)
      list(
        List
          .new(expr.body.map { |e| call(e) })
          .push(expr.params)
          .push(SYM_LAMBDA)
      )
    end

    def context(expr)
      context_bindings(expr).join("\n")
    end

    def null(_expr)
      "NIL"
    end

    def default(expr)
      expr
    end

    def context_bindings(expr, sep: "")
      own = expr.bindings
                .map { |tuple| "#{sep}#{call(tuple[0])}: #{call(tuple[1])}" }
      return own if expr.fallback.nil?

      own + context_bindings(expr.fallback, sep: "#{sep}  ")
    end
  end
end
