RSpec.describe Campa::Evaler do
  subject(:evaler) { described_class.new }

  def symbol(label)
    Campa::Symbol.new(label)
  end

  describe "#call", "expressions" do
    context "when evaluating 'primitives'" do
      it "returns the integer passed as param" do
        expect(evaler.call(1)).to eq 1
      end

      it "returns the float passed" do
        expect(evaler.call(4.2)).to eq 4.2
      end

      it "doesn't discriminate agains negatives XD" do
        expect(evaler.call(-4.2)).to eq(-4.2)
      end

      it "returns true when receiving it" do
        expect(evaler.call(true)).to eq true
      end

      it "returns false when receiving it" do
        expect(evaler.call(false)).to eq false
      end

      it "returns nil when receiving it" do
        expect(evaler.call(nil)).to eq nil
      end
    end

    context "when resolving symbols" do
      it "returns the value associated with a symbol" do
        env = { symbol("time") => 420 }

        expect(evaler.call(symbol("time"), env)).to eq 420
      end

      it "raises if symbol is unbound" do
        expect { evaler.call(symbol("oh_nos")) }
          .to raise_error(Campa::ResolutionError)
      end
    end


        expect(evaler.call(Campa::Symbol.new("time"), env)).to eq 420
      end
    end
  end
end
