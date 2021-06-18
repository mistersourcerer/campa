RSpec.describe Campa::Lisp::Core do
  subject(:lisp) { described_class.new }

  let(:evaler) { Campa::Evaler.new }

  describe "#quote" do
    it "returns the expression without evaluating it" do
      ivk = list(symbol("quote"), list(symbol("+"), 1, 2))

      expect(evaler.call(ivk, lisp)).to eq list(symbol("+"), 1, 2)
    end
  end
end
