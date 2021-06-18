RSpec.describe Campa::Lisp::Quote do
  subject(:quote) { described_class.new }

  it { is_expected.to be_macro }

  it "returns the parameters without evaluating it" do
    expect(quote.call(symbol("a"), {})).to eq symbol("a")
  end

  it "works with lists also" do
    expect(quote.call(list(symbol("a"), "b"), {}))
      .to eq list(symbol("a"), "b")
  end
end
