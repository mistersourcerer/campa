RSpec.describe Campa::Lisp::LambdaFn do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }
  let(:root) { Campa.root }

  context "when lambda has no arguments" do
    it "raises if parameters list is invalid (containing more then symbols)" do
      ivk = invoke("lambda", list(symbol("print"), 1), 1)

      expect { evaler.call(ivk, lisp) }.to raise_error(
        Campa::Error::Parameters,
        "Parameter list may only contain symbol: 1 is not a symbol"
      )
    end

    it "creates the lambda object" do
      ivk = invoke("lambda", list, invoke("quote", symbol("a")))

      expect(evaler.call(ivk, lisp))
        .to eq Campa::Lambda.new(list, [invoke("quote", symbol("a"))])
    end

    it "ensures lambda is created with the invocation env as a closure" do
      ivk = invoke("lambda", list, symbol("a"))
      ctx = Campa::Context.new(symbol("a") => 4.20)

      expect(evaler.call(ivk, lisp.push(ctx)).call(env: lisp)).to eq 4.20
    end

    it "can be invoked inline" do
      ctx = Campa::Context.new(symbol("a") => 4.20)
      ivk = list(invoke("lambda", list, symbol("a")))

      expect(evaler.call(ivk, lisp.push(ctx))).to eq 4.20
    end
  end

  context "when lambda has arguments" do
    it "can be invoked inline" do
      ivk = list(invoke("lambda", list(symbol("a")), symbol("a")), 4.20)

      expect(evaler.call(ivk, lisp)).to eq 4.20
    end

    # rubocop: disable RSpec/ExampleLength
    it "allows to pass a lambda as argument" do
      lambda_cons = invoke(
        "lambda",
        list(symbol("x")),
        invoke("cons", invoke("quote", symbol("a")), symbol("x"))
      )

      lambda_ivk = invoke(
        "lambda",
        list(symbol("f")),
        invoke("f", invoke("quote", list(symbol("b"), symbol("c"))))
      )

      ivk = list(lambda_ivk, invoke("quote", lambda_cons))
      evaler.call(ivk, lisp)
    end
    # rubocop: enable RSpec/ExampleLength
  end

  context "when there is a 'deeper' context (fallback) during the execution" do
    let(:lang) { Campa::Language.new }
    let(:ctx) { lang.push(Campa::Context.new) }

    it "finds the correct functions" do
      Campa::Core::Load
        .new
        .call(root.join("../spec/example.cmp"), env: ctx)

      evaler.call(invoke("is-one?", 1), ctx)
    end
  end
end
