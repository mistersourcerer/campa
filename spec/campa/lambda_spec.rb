RSpec.describe Campa::Lambda do
  let(:lisp) { Campa::Lisp::Core.new }

  describe "#==" do
    it "considers the parameters when comparing lambdas" do
      lbd1 = described_class.new(list(symbol("a"), symbol("b")), [1])
      lbd2 = described_class.new(list(symbol("a"), symbol("b")), [1])
      lbd3 = described_class.new(list(symbol("c"), symbol("d")), [1])

      expect([lbd1 == lbd2, lbd2 == lbd3]).to eq [true, false]
    end

    it "considers the body when comparing lambdas" do
      lbd1 = described_class.new(list(symbol("a"), symbol("b")), [1])
      lbd2 = described_class.new(list(symbol("a"), symbol("b")), [1])
      lbd3 = described_class.new(list(symbol("a"), symbol("b")), [2])

      expect([lbd1 == lbd2, lbd2 == lbd3]).to eq [true, false]
    end
  end

  describe "#call" do
    it "raises when arity doesn't match" do
      fun = described_class.new(list(symbol("a")), [nil])

      expect { fun.call(1, 2, env: lisp) }.to raise_error(
        Campa::Error::Arity,
        "Arity error when invoking lambda: expected 1 arg(s) but 2 given"
      )
    end

    it "evaluates the function within the given context" do
      fun = described_class.new(
        list,
        [invoke("quote", symbol("a")), 4.20, "omg"]
      )

      expect(fun.call(env: lisp)).to eq "omg"
    end

    # rubocop: disable RSpec/ExampleLength
    it "binds the parameters to the arguments when executing" do
      fun_eq = described_class.new(
        list(symbol("a"), symbol("b")),
        [invoke("eq", symbol("a"), symbol("b"))]
      )
      fun_ret = described_class.new(list(symbol("x")), [symbol("x")])
      result = [
        fun_eq.call(1, 1, env: lisp),
        fun_eq.call(1, 2, env: lisp),
        fun_ret.call("4.20", env: lisp)
      ]

      expect(result).to eq [true, false, "4.20"]
    end
    # rubocop: enable RSpec/ExampleLength

    it "executes the function on it's own context" do
      context = lisp.push(Campa::Context.new(symbol("x") => "no"))
      fun = described_class.new(list(symbol("x")), [symbol("x")])

      expect([fun.call("4.20", env: context), context[symbol("x")]])
        .to eq ["4.20", "no"]
    end

    context "when using values from the closure environment" do
      it "carries the closure from when function was created" do
        creation_context = Campa::Context.new(symbol("a") => 4.20)
        fun = described_class.new(list, [symbol("a")], creation_context)

        expect(fun.call(env: lisp)).to eq 4.20
      end

      it "ensures invocation context has bigger priority (over closure)" do
        creation_context = Campa::Context.new(symbol("a") => 4.20)
        fun = described_class.new(list, [symbol("a")], creation_context)
        ivk_context = Campa::Context.new(symbol("a") => "bbq")

        expect(fun.call(env: lisp.push(ivk_context))).to eq "bbq"
      end
    end
  end
end
