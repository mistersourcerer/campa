module Campa
  class Cli
    def initialize(repl: nil, evaler: nil, context: nil, reader: nil)
      @evaler = evaler || default_evaler
      @context = context || default_context
      @reader = reader || default_reader

      @repl = repl || default_repl
    end

    def execute(argv = nil, input: $stdin, out: $stdout)
      return repl.run(input, out) if argv.nil? || argv.empty?
      return evaluate(argv[0], input, out) if File.file?(argv[0])

      execute_option(argv[0].to_sym, argv[1..], input, out)
    end

    private

    OPTIONS = {
      test: :test,
    }.freeze

    attr_reader :repl, :evaler, :context, :reader

    def new_eval_ctx(out)
      context.push(Symbol.new("__out__") => out)
    end

    def evaluate(file, _, out)
      evaler.eval(reader.new(file), new_eval_ctx(out))
      exit(0)
    end

    def execute_option(option, args, input, out)
      method = OPTIONS.fetch(option) { raise "Unknown option #{option}" }
      method(method).call(args, input, out)
    end

    def test(files, _, out)
      eval_ctx = new_eval_ctx(out)
      files.each { |file| evaler.eval(reader.new(file), eval_ctx) }
      results = Campa::Core::Test.new.call(env: eval_ctx)
      reporter = Campa::Core::TestReport.new
      exit(0) if reporter.call(results, env: eval_ctx)
      exit(1)
    end

    def default_repl
      @default_repl ||= Campa::Repl.new(evaler, context)
    end

    def default_evaler
      @default_evaler ||= Campa::Evaler.new
    end

    def default_context
      @default_context ||= Campa::Language.new
    end

    def default_reader
      @default_reader ||= Campa::Reader
    end
  end
end
