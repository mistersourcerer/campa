module Campa
  # Represents a <i>Campa</i> expression
  # in a human readable form.
  #
  # In general it tries to create a representation
  # that is valid <i>Campa</i> code
  # to make it easy(ier) to copy and paste stuff
  # from the REPL to a file.
  #
  # @example some results produced by {Printer}
  #   printer = Printer.new
  #
  #   printer.call("lol") #=> "lol"
  #   printer.call("lol") #=> 123
  #   printer.call(List.new("bbq", 420, List.new("yes"))) #=> ("bbq" 420 ("yes"))
  class Printer
    # @param expr [Object] <i>Campa</i> expression to be respresented in
    #   human readable form
    # @return [String] human readable form (almost always valid code)
    #   of an Expression
    def call(expr)
      format = FORMATS.fetch(expr.class) do
        expr.is_a?(Context) ? :context : :default
      end
      send(format, expr)
    end

    private

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
          .push(SYMBOL_LAMBDA)
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
      own =
        expr
        .bindings
        .map { |tuple| "#{sep}#{call(tuple[0])}: #{call(tuple[1])}" }
      return own if expr.fallback.nil?

      own + context_bindings(expr.fallback, sep: "#{sep}  ")
    end
  end
end
