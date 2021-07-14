RSpec.describe Campa::Context do
  subject(:context) { described_class.new }

  context "when accessing bindings" do
    it "behaves like a hash on writing and reading" do
      context[symbol("lol")] = 1

      expect(context[symbol("lol")]).to eq 1
    end

    it "behaves like a hash on #include?" do
      context[symbol("lol")] = 1

      expect(context.include?(symbol("lol"))).to eq true
    end
  end

  describe "#push" do
    it "returns a new context with the bindings given already there" do
      new_context = context.push(symbol("zig") => "zag")

      expect(new_context[symbol("zig")]).to eq "zag"
    end

    it "accepts an actual context to be pushed" do
      context[symbol("zig")] = "NEIN!"
      new_context = described_class.new(symbol("zig") => "zag")
      another = context.push new_context

      expect([another[symbol("zig")], context[symbol("zig")]])
        .to eq ["zag", "NEIN!"]
    end
  end

  describe "#[]" do
    context "when there are stacked environments" do
      # rubocop:disable RSpec/ExampleLength
      it "returns the binding in the last environment" do
        context[symbol("dont_touchme")] = "ok"
        new_context = context.push(symbol("dont_touchme") => "nok")
        another = new_context.push(symbol("dont_touchme") => "eew")

        expect(
          [
            another[symbol("dont_touchme")],
            new_context[symbol("dont_touchme")],
            context[symbol("dont_touchme")]
          ]
        ).to match_array %w[eew nok ok]
      end
      # rubocop:enable RSpec/ExampleLength

      it "fallbacks to the underlying environments" do
        context[symbol("time")] = 420
        new_context = context.push
        another = new_context.push

        expect(another[symbol("time")]).to eq 420
      end
    end
  end
end
