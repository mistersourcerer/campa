RSpec.describe Campa::Evaler do
  subject(:evaler) { described_class.new }

  def symbol(label)
    Campa::Symbol.new(label)
  end

  def list(*args)
    Campa::List.new(*args)
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

    context "when evaling lists" do
      it "invokes the bounded function in the environment" do
        env = { symbol("fun") => -> { "yes" } }
        invocation = list(symbol("fun"))

        expect(evaler.call(invocation, env)).to eq "yes"
      end

      it "passes arguments to the bounded function" do
        env = { symbol("fun") => ->(time) { time } }
        invocation = list(symbol("fun"), 420)

        expect(evaler.call(invocation, env)).to eq 420
      end

      it "passes multiple params to the function" do
        env = { symbol("fun") => ->(*stuffs) { stuffs } }
        invocation = list(symbol("fun"), 420, "there is", "things", :also)

        expect(evaler.call(invocation, env)).to eq [
          420, "there is", "things", :also
        ]
      end
    end
  end
end
