module Campa
  class Language < Lisp::Core
    def initialize
      super

      Campa::Core::Load
        .new
        .call(Campa.root.join("../campa/core.cmp"), env: self)
    end
  end
end
