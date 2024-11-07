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

    expect(evaler.call(invocation, env)).to contain_exactly(420, "there is", "things", :also)
  end

  # rubocop: disable RSpec/ExampleLength
  it "evaluates params before passing them down" do
    env = {
      symbol("fun") => ->(*stuffs) { stuffs },
      symbol("num") => 420,
      symbol("str") => "stuff"
    }
    invocation = list(symbol("fun"), symbol("num"), symbol("str"))

    expect(evaler.call(invocation, env)).to contain_exactly(420, "stuff")
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

  xit "ensures the function has it's own context"

  context "when invoking a /c(a|d)+r/ function" do
    let(:cadr) do
      Class.new do
        def call(operation, list)
          [operation, list]
        end

        def macro?
          true
        end
      end
    end

    # rubocop: disable RSpec/ExampleLength
    it "dispatches the invocation to (cadr ...)" do
      ctx = {
        symbol("quote") => Campa::Lisp::Quote.new,
        symbol("_cadr") => cadr.new
      }
      list = invoke("quote", list(1, 2, 3, 4))

      expect(evaler.call(invoke("caaddr", list), ctx))
        .to eq [symbol("caaddr"), list(1, 2, 3, 4)]
    end
    # rubocop: enable RSpec/ExampleLength
  end
end
