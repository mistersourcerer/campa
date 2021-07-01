RSpec.describe Campa::Lisp::Label do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }
  let(:context) { lisp.push Campa::Context.new }

  describe "(label ...)" do
    it "binds a value to the given symbol on a given context" do
      evaler.call(invoke("label", symbol("x"), 4.20), context)

      expect(context[symbol("x")]).to eq 4.20
    end

    it "works with function even without quoting it" do
      fun = invoke("lambda", list(symbol("x")), invoke("eq", symbol("x"), 4.20))
      ivk = invoke("label", symbol("fun"), fun)
      evaler.call(ivk, context)

      expect(evaler.call(invoke("fun", 4.20), context)).to eq true
    end

    context "when ensuring to cover Roots of Lisp XD" do
      # (cond ((eq 1 2) 'x) (true 'z)))
      let(:reader) do
        Campa::Reader.new(<<~LISP)
          (label subst (lambda (x y z)
                        (cond ((atom z)
                               (cond ((eq z y) x)
                                     (true z)))
                              (true (cons (subst x y (car z))
                                          (subst x y (cdr z)))))))
        LISP
      end

      let(:invocation) { Campa::Reader.new("(subst 'm 'b '(a b (a b c) d))") }

      # rubocop: disable RSpec/ExampleLength
      it "knows how to recurrently call a function" do
        evaler.eval(reader, context)

        expect(evaler.eval(invocation, context)).to eq list(
          symbol("a"), symbol("m"),
          list(symbol("a"), symbol("m"), symbol("c")),
          symbol("d")
        )
      end
      # rubocop: enable RSpec/ExampleLength
    end
  end
end
