RSpec.describe Campa::Evaler, "#call" do
  subject(:evaler) { described_class.new }

  let(:macro) do
    Class.new do
      def call(something)
        something
      end

      def macro?
        true
      end
    end
  end

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
      420, "there is", "things", :also
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

    expect(evaler.call(invocation, env)).to match_array [420, "stuff"]
  end
  # rubocop: enable RSpec/ExampleLength

  it "raises if symbol does not resolve to a function" do
    env = { symbol("nein") => "no #call" }

    expect { evaler.call(invoke("nein"), env) }
      .to raise_error Campa::Error::NotAFunction
  end

  it "passes the args without evaluation when #macro? is true" do
    env = { symbol("fun") => macro.new }

    expect(evaler.call(invoke("fun", 420), env)).to eq 420
  end

  # rubocop: disable RSpec/ExampleLength
  it "passes down the env if function asks for it via named param" do
    ctx = {
      "something" => "to check",
      symbol("fun") => proc { |env:| env }
    }
    result = evaler.call(invoke("fun", 420), ctx)

    expect(result["something"]).to eq "to check"
  end
  # rubocop: enable RSpec/ExampleLength

  it "evaluates empty lists to themselves" do
    expect(evaler.call(list)).to eq list
  end

  xit "ensures the function has it's own context" do
  end
end
