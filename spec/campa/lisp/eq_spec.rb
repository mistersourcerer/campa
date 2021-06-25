RSpec.describe Campa::Lisp::Eq do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }

  describe "(eq ...)" do
    it "returns true if both atoms are the same" do
      ivk = invoke(
        "eq", invoke("quote", symbol("a")), invoke("quote", symbol("a"))
      )

      expect(evaler.call(ivk, lisp)).to eq true
    end

    it "returns true if both params are empty lists" do
      ivk = invoke("eq", invoke("quote", list), invoke("quote", list))

      expect(evaler.call(ivk, lisp)).to eq true
    end

    it "returns true if symbol bindings are the same" do
      ctx = lisp.push(
        Campa::Context.new(symbol("a") => 420, symbol("b") => 420)
      )
      ivk = invoke("eq", symbol("a"), symbol("b"))

      expect(evaler.call(ivk, ctx)).to eq true
    end
  end
end
