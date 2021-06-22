RSpec.describe Campa::Repl do
  subject(:repl) { described_class.new(evaler, lisp) }

  let(:evaler) { Campa::Evaler.new }
  let(:lisp) { Campa::Lisp::Core.new }
  let(:output) { StringIO.new }
  let(:context) { Context.new }

  def input(with)
    StringIO.new with
  end

  describe "#run" do
    it "waits for input on a IO like object" do
      repl.run(input("1\n"), output)

      expect(output.string).to eq "1\n"
    end

    it "outputs the result of evaling multiple expressions in line" do
      repl.run(input("1 \"two\" 4.2 "), output)

      expect(output.string).to eq "1\n\"two\"\n4.2\n"
    end
  end
end
