RSpec.describe Campa::Core::PrintLn do
  let(:ctx) { Campa::Language.new.push Campa::Context.new }
  let(:evaler) { Campa::Evaler.new }
  let(:output) { StringIO.new }

  before do
    ctx[symbol("__out__")] = output
  end

  describe "(println ...)" do
    it "prints the parameter to the output" do
      evaler.call(invoke("println", "bbq!"), ctx)

      expect(output.string).to eq "bbq!\n"
    end

    it "joins the parameters with a space and print it out" do
      evaler.call(invoke("println", "omg", invoke("quote", symbol("lol")), 420), ctx)

      expect(output.string).to eq "omg\nlol\n420\n"
    end

    it "returns nil" do
      expect(evaler.call(invoke("println", "omg", "lol", "bbq!"), ctx))
        .to eq nil
    end
  end
end
