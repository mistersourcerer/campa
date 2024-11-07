RSpec.describe Campa::Evaler do
  subject(:evaler) { described_class.new }

  describe "#call", "expressions" do
    context "when evaluating 'primitives'" do
      it "evaluates numberics" do
        expect([evaler.call(1), evaler.call(4.2), evaler.call(-4.2)])
          .to eq [1, 4.2, -4.2]
      end

      it "evaluates booleans to themselves" do
        expect([evaler.call(false), evaler.call(true)]).to eq [false, true]
      end

      it "returns nil when receiving it" do
        expect(evaler.call(nil)).to be_nil
      end

      it "returns string when receiving it" do
        expect(evaler.call("42")).to eq "42"
      end
    end

    context "when resolving symbols" do
      it "returns the value associated with a symbol" do
        env = { symbol("time") => 420 }

        expect(evaler.call(symbol("time"), env)).to eq 420
      end

      it "raises if symbol is unbound" do
        expect { evaler.call(symbol("oh_nos")) }
          .to raise_error(Campa::Error::Resolution)
      end
    end
  end

  describe "#eval" do
    let(:context) { Campa::Lisp::Core.new.push(Campa::Context.new) }
    let(:reader) do
      Campa::Reader.new(<<~CODE)
        (label omg 4.20)
        (label fun (lambda (x) x))
        (fun omg)
      CODE
    end

    it "evaluates the whole code given to a reader" do
      expect(evaler.eval(reader, context)).to eq 4.20
    end
  end
end
