module Campa
  class Repl
    def initialize(evaler, context, reader: Reader)
      @reader = reader
      @evaler = evaler
      @context = context
      @environment = Context.new(@context)
    end

    # rubocop: disable Metrics/MethodLength
    def run(input, output)
      output.print "=> "
      reader = @reader.new(input)

      loop do
        begin
          token = reader.next
          break if token.nil?

          show(output, @evaler.call(token, @environment))
        rescue ExecutionError => e
          output.puts "Execution Error: #{e.class}"
          output.puts e.message
        end

        output.print "=> "
      end
    end
    # rubocop: enable Metrics/MethodLength

    private

    def show(output, result)
      output
        .puts(
          format(
            result
          )
        )
    end

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
