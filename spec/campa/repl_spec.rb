RSpec.describe Campa::Repl do
  subject(:repl) { described_class.new(evaler, lisp) }

  let(:evaler) { Campa::Evaler.new }
  let(:lisp) { Campa::Lisp::Core.new }
  let(:context) { Context.new }
  let(:output) { StringIO.new }

  def input(with = "\n")
    StringIO.new with
  end

  describe "#run" do
    it "prompts user waiting from code" do
      repl.run(input, output)

      expect(output.string.split("\n")[0]).to eq "=> "
    end

    it "waits for input on a IO like object" do
      repl.run(input("1\n"), output)

      expect(output.string.split("\n")).to eq ["=> 1", "=> "]
    end

    it "outputs the result of evaling multiple expressions in line" do
      repl.run(input("1 \"two\" 4.2 "), output)
      result = output.string.split("=> ")

      expect([result[1], result[2], result[3]])
        .to eq ["1\n", "\"two\"\n", "4.2\n"]
    end

    context "when handling reader/evaler exceptions" do
      # rubocop: disable RSpec/ExampleLength
      it "shows the error and waits for next input" do
        repl.run(input("(non-existent-fun 1)\n"), output)

        expect(output.string.split("\n")).to eq [
          "=> Execution Error: Campa::Error::Resolution",
          "Unable to resolve symbol: non-existent-fun in this context",
          "=> "
        ]
      end
      # rubocop: enable RSpec/ExampleLength
    end

    # rubocop: disable RSpec/MultipleMemoizedHelpers, RSpec/VerifiedDoubles
    context "when handling interruption" do
      subject(:repl) do
        described_class.new(evaler, lisp, reader: reader_class)
      end

      let(:broken_reader) { double }
      let(:reader_class) { double(new: broken_reader) }

      it "shows a polite good bye message" do
        allow(broken_reader).to receive(:next).and_raise(Interrupt)
        repl.run(input, output)

        expect(output.string).to eq "=> see you soon\n"
      end
    end
    # rubocop: enable RSpec/MultipleMemoizedHelpers, RSpec/VerifiedDoubles
  end
end
