module Campa
  class Repl
    def initialize(evaler, context, reader: Reader)
      @reader = reader
      @evaler = evaler
      @context = context
      @environment = @context.push(Context.new)
      @printer = Printer.new
    end

    # rubocop: disable Metrics/MethodLength
    def run(input, output)
      output.print "=> "
      reader = @reader.new(input)

      loop do
        begin
          token = reader.next
          break if token.nil?

          show(output, evaler.call(token, environment))
        rescue ExecutionError => e
          handle_exec_error(output, e)
        rescue StandardError => e
          handle_standard_error(output, e)
        end

        output.print "=> "
      end
    rescue Interrupt
      output.puts "see you soon"
    end
    # rubocop: enable Metrics/MethodLength

    private

    attr_reader :evaler, :environment, :printer

    def show(output, result)
      output
        .puts(
          printer.call(
            result
          )
        )
    end

    def handle_exec_error(output, exception)
      [
        "Execution Error: #{exception.class}",
        "  message: #{exception.message}",
        "  >> Runtime details:",
        back_trace_to_s(exception),
      ].each { |str| output.puts str }
    end

    def handle_standard_error(output, exception)
      [
        "FATAL!",
        "Exeception error was raised at Runtime level",
        "Runtime Error: #{exception.class}",
        "  message: #{exception.message}",
        back_trace_to_s(exception),
      ].each { |str| output.puts str }
    end

    def back_trace_to_s(exception)
      exception
        .backtrace[0..10]
        .push("...")
        .map { |s| "    #{s}" }
        .join("\n")
    end
  end
end
