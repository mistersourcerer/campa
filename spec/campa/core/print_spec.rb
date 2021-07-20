RSpec.describe Campa::Core::Print do
  let(:ctx) { Campa::Language.new.push Campa::Context.new }
  let(:evaler) { Campa::Evaler.new }
  let(:output) { StringIO.new }

  before do
    ctx[symbol("__out__")] = output
  end

  describe "(print ...)" do
    it "prints the parameter to the output" do
      evaler.call(invoke("print", "bbq!"), ctx)

      expect(output.string).to eq "\"bbq!\""
    end

    it "joins the parameters with a space and print it out" do
      evaler.call(invoke("print", "omg", "lol", 420), ctx)

      expect(output.string).to eq "\"omg\" \"lol\" 420"
    end

    it "returns nil" do
      expect(evaler.call(invoke("print", "omg", "lol", "bbq!"), ctx))
        .to eq nil
    end

    it "uses the campa printer to output 'objects'" do
      list = list(symbol("omg"), "lol", symbol("bbq"), list(4, 20))
      evaler.call(invoke("print", invoke("quote", list)), ctx)

      expect(output.string).to eq "(omg \"lol\" bbq (4 20))"
    end
  end
end
