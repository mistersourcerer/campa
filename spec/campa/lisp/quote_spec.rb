RSpec.describe Campa::Lisp::Quote do
  subject(:quote) { described_class.new }

  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }

  it { is_expected.to be_macro }

  describe "#call" do
    it "returns the parameters without evaluating it" do
      expect(quote.call(symbol("a"), {})).to eq symbol("a")
    end

    it "works with lists also" do
      expect(quote.call(list(symbol("a"), "b"), {}))
        .to eq list(symbol("a"), "b")
    end
  end

  describe "(quote ...)" do
    it "returns the expression without evaluating it" do
      ivk = invoke("quote", invoke("+", 1, 2))

      expect(evaler.call(ivk, lisp)).to eq list(symbol("+"), 1, 2)
    end
  end
end
