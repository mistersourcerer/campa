RSpec.describe Campa::Lisp::Defun do
  subject(:defun) { described_class.new }

  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }
  let(:context) { lisp.push Campa::Context.new }

  it { is_expected.to be_macro }

  describe "(defun ...)" do
    it "creates a function bound to the symbol (first param)" do
      declaration =
        invoke("defun", symbol("fun"), list(symbol("x")), "something", symbol("x"))
      evaler.call(declaration, context)

      expect(evaler.call(invoke("fun", 4.20), context)).to eq 4.20
    end

    it "raises if first parameter is not a symbol" do
      declaration = invoke("defun", list(symbol("x")), symbol("x"))

      expect { evaler.call(declaration, context) }.to raise_error(
        Campa::Error::IllegalArgument,
        "Illegal argument: (x) was expected to be a symbol"
      )
    end

    it "raises if arguments list is illegal" do
      declaration = invoke("defun", symbol("fun"), "x", symbol("x"))

      expect { evaler.call(declaration, context) }.to raise_error(
        Campa::Error::Parameters,
        "Parameter list may only contain list of symbols: \"x\" is not a list of symbols"
      )
    end

    context "when function has muli-expression body" do
      # rubocop: disable RSpec/ExampleLength
      it "creates the adequate lambda for it" do
        declaration = invoke(
          "defun",
          symbol("fun"),
          list(symbol("x"), symbol("y")),
          symbol("x")
        )
        lbd = evaler.call(declaration, context)

        expect([lbd, lbd.call(4.20, 1, env: context)]).to eq [
          Campa::Lambda.new(list(symbol("x"), symbol("y")), symbol("x")),
          4.20
        ]
      end
      # rubocop: enable RSpec/ExampleLength
    end

    context "when ensuring to cover Roots of Lisp XD" do
      let(:reader) do
        Campa::Reader.new(<<~LISP)
          (defun subst (x y z)
            (cond ((atom z)
                   (cond ((eq z y) x)
                         (true z)))
                  (true (cons (subst x y (car z))
                              (subst x y (cdr z))))))
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
