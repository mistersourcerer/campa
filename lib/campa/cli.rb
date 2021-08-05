module Campa
  # Implements the features available
  # to the command `campa` shipped with this gem.
  class Cli
    # @param repl [#run] the repl to be run if no option is given to `campa`
    # @param evaler [#eval] lisp/campa evaler to be used
    #   by the repl or file evaluation
    # @param context [#push, #[], #[]=] the context provider
    #   for the current run.
    #   This is where the __out__ binding pointing to $stdout will be created.
    # @param reader [#new] lisp/campa reader for when
    #   an existent file is passed to `campa`.
    def initialize(repl: nil, evaler: nil, context: nil, reader: Campa::Reader)
      @evaler = evaler || default_evaler
      @context = context || default_context
      @reader = reader

      @repl = repl || default_repl
    end

    # Execute some campa stuff
    # depending on the options given in the command line.
    #
    # If no argument is given
    # it will start a {Campa::Repl} session.
    #
    # When first argument is an existent file
    # then it will evaluated using {Campa::Reader} and {Campa::Evaler}.
    #
    # If the CLI argument is anything else,
    # this method tries to match it with {OPTIONS}
    # and find the method to be executed.
    # Current options for the CLI are:
    #
    # <b><i>campa test FILE1, FILE2</i></b>
    # Uses {Campa::Core::Test} and {Campa::Core::TestReport} to evaluate
    # the files given as options as *Campa* test code.
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
      context.push(SYMBOL_OUT => out)
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
      code = reporter.call(results, env: eval_ctx) ? 0 : 1

      exit(code)
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
  end
end
