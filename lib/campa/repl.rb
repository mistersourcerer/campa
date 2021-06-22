module Campa
  class Repl
    def initialize(evaler, context, reader: Reader)
      @reader = reader
      @evaler = evaler
      @context = context
      @environment = Context.new(@context)
    end

    def run(input, output)
      reader = @reader.new(input)
      while (token = reader.next)
        output
          .puts(
            format(
              @evaler.call(token, @environment)
            )
          )
      end
    end

    private

    def format(result)
      case result
      when String
        "\"#{result}\""
      when Symbol
        result.label
      when List
        "(#{result.map { |el| format(el) }.join(" ")})"
      else
        result
      end
    end
  end
end
