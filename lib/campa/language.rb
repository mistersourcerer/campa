module Campa
  class Language < Lisp::Core
    def initialize
      super
      load_core_funs
      load_core_files
    end

    private

    FUNS = {

      "print": Core::Print.new,
      "println": Core::PrintLn.new,
    }.freeze

    FILES = [
      "../campa/core.cmp",
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
