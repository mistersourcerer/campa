RSpec.describe Campa::Lisp::Atom do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }

  describe "(atom ...)" do
    it "returns true for symbols" do
      ivk = invoke("atom", invoke("quote", symbol("a")))

      expect(evaler.call(ivk, lisp)).to eq true
    end

    it "returns true for primitives" do
      result = [4.20, "42", true, false]
               .map { |prim| invoke("atom", prim) }
               .map { |ivk| evaler.call(ivk, lisp) }

      expect(result).to eq [true, true, true, true]
    end

    it "returns true for empty lists" do
      ivk = invoke("atom", invoke("quote", list))

      expect(evaler.call(ivk, lisp)).to eq true
    end

    it "returns false for non-empty lists" do
      ivk = invoke("atom", invoke("quote", list(1, 2)))

      expect(evaler.call(ivk, lisp)).to eq false
    end
  end
end
