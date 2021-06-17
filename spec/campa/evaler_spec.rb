RSpec.describe Campa::Evaler do
  subject(:evaler) { described_class.new }

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
  end
end
