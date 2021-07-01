module Campa
  class Printer
    FORMATS = {
      String => :string,
      Symbol => :symbol,
      List => :list,
      TrueClass => :boolean,
      FalseClass => :boolean,
      Lambda => :lambda,
    }.freeze

    def call(expr)
      format = FORMATS.fetch(expr.class, :default)
      send(format, expr)
    end

    private

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
          .push(Symbol.new("lambda"))
      )
    end

    def default(expr)
      expr
    end
  end
end
