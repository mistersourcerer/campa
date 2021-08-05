module Campa
  # {Context} wrapping the core bindings
  # that form the core for <b>Campa</b> (language).
  #
  # It extends {Lisp::Core} to add
  #   - (test-run ...)
  #   - (tests-report)
  #   - (print ...)
  #   - (println ...)
  class Language < Lisp::Core
    def initialize
      super
      load_core_funs
      load_core_files
    end

    private

    FUNS = {
      "tests-run": Core::Test.new,
      "tests-report": Core::TestReport.new,

      "print": Core::Print.new,
      "println": Core::PrintLn.new,
    }.freeze

    FILES = [
      "../campa/core.cmp",
      "../campa/test.cmp",
    ].freeze

    def load_core_funs
      FUNS.each { |label, fun| self[Symbol.new(label.to_s)] = fun }
    end

    def load_core_files
      loader = Campa::Core::Load.new
      FILES.each { |f| loader.call(Campa.root.join(f), env: self) }
    end
  end
end
