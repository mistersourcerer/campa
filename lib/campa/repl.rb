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
      return "\"#{result}\"" if result.is_a?(String)

      result
    end
  end
end
