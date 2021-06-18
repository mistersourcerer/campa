RSpec.describe Campa::Evaler do
  subject(:evaler) { described_class.new }

  let(:macro) do
    Class.new do
      def call(something, env)
        [something, env]
      end

      def macro?
        true
      end
    end
  end

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
          .to raise_error(Campa::ResolutionError)
      end
    end

    context "when evaling lists" do
      it "invokes the bounded function in the environment" do
        env = { symbol("fun") => proc { "yes" } }
        invocation = list(symbol("fun"))

        expect(evaler.call(invocation, env)).to eq "yes"
      end

      it "passes arguments to the bounded function" do
        env = { symbol("fun") => proc { |time| time } }
        invocation = list(symbol("fun"), 420)

        expect(evaler.call(invocation, env)).to eq 420
      end

      it "passes multiple params to the function" do
        env = { symbol("fun") => ->(*stuffs) { stuffs } }
        invocation = list(symbol("fun"), 420, "there is", "things", :also)

        expect(evaler.call(invocation, env)).to match_array [
          420, "there is", "things", :also, Campa::Context
        ]
      end

      # rubocop: disable RSpec/ExampleLength
      it "evaluates params before passing them down" do
        env = {
          symbol("fun") => ->(*stuffs) { stuffs },
          symbol("num") => 420,
          symbol("str") => "stuff"
        }
        invocation = list(symbol("fun"), symbol("num"), symbol("str"))

        expect(evaler.call(invocation, env))
          .to match_array [420, "stuff", Campa::Context]
      end
      # rubocop: enable RSpec/ExampleLength

      it "raises if symbol does not resolve to a function" do
        env = { symbol("nein") => "no #call" }
        invocation = list(symbol("nein"))

        expect { evaler.call(invocation, env) }
          .to raise_error Campa::NotAFunctionError
      end

      it "passes the args without evaling plus the context/env to macros" do
        env = { symbol("fun") => macro.new }
        invocation = list(symbol("fun"), 420)

        expect(evaler.call(invocation, env))
          .to match_array [420, Campa::Context]
      end

      it "ensures the function has it's own context" do
        env = { symbol("fun") => proc { |e| e[:nein] = false } }
        invocation = list(symbol("fun"))
        evaler.call(invocation, env)

        expect(env[:nein]).to eq nil
      end
    end
  end
end
