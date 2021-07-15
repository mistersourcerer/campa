RSpec.describe Campa::Core::Load do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }
  let(:ctx) { lisp.push Campa::Context.new }
  let(:root) { Campa.root }

  describe "(load ...)" do
    # rubocop: disable RSpec/ExampleLength
    it "evaluates a file content in the current context" do
      evaler.call(invoke("load", root.join("../spec/example.cmp").to_s), ctx)
      result = [
        evaler.call(invoke("hi-there", "Marvin"), ctx),
        evaler.call(invoke("echo", 420), ctx)
      ]

      expect(result).to eq ["Marvin", 420]
    end
    # rubocop: enable RSpec/ExampleLength

    it "raises if file doesn't exist" do
      ivk = invoke("load", root.join("spec/nope.cmp").to_s)

      expect { evaler.call(ivk, ctx) }.to raise_error(
        Campa::Error::NotFound,
        "Can't find a file at: #{root.join("spec/nope.cmp")}"
      )
    end

    # rubocop: disable RSpec/ExampleLength
    it "raises if any file given doesn't exist" do
      ivk = invoke(
        "load",
        root.join("spec/example.cmp").to_s,
        root.join("spec/nope.cmp").to_s
      )

      expect { evaler.call(ivk, ctx) }.to raise_error(
        Campa::Error::NotFound,
        "Can't find a file at: #{root.join("spec/example.cmp")}"
      )
    end
    # rubocop: enable RSpec/ExampleLength
  end
end
