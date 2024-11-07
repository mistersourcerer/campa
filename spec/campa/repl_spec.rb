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
      it "shows the error and waits for next input" do
        repl.run(input("(non-existent-fun 1)\n"), output)

        expect(output.string.split("\n")[0..1]).to eq [
          "=> Execution Error: Campa::Error::Resolution",
          "  message: Unable to resolve symbol: non-existent-fun in this context"
        ]
      end
    end

    # rubocop: disable RSpec/MultipleMemoizedHelpers
    context "when handling exceptions" do
      subject(:repl) { described_class.new(evaler, lisp, reader: reader_class) }

      let(:broken_reader) { instance_double(Campa::Reader) }
      let(:reader_class) { instance_double(Class, new: broken_reader) }

      it "shows a polite good bye message when Interrupt is raised" do
        allow(broken_reader).to receive(:next).and_raise(Interrupt)
        repl.run(input, output)

        expect(output.string).to eq "=> see you soon\n"
      end

      # rubocop: disable RSpec/ExampleLength
      it "handles standard error exceptions without closing the repl" do
        first = true
        allow(broken_reader).to receive(:next) do
          if first
            first = false
            raise "nope"
          end
        end
        repl.run(input, output)

        expect(output.string.split("\n")[-1]).to eq "=> "
      end
      # rubocop: enable RSpec/ExampleLength
    end
    # rubocop: enable RSpec/MultipleMemoizedHelpers
  end
end
