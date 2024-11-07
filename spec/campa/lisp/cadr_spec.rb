RSpec.describe Campa::Lisp::Cadr do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }
  let(:printer) { Campa::Printer.new }

  describe "(cadr ...)" do
    let(:quote_list) do
      invoke(
        "quote",
        list(
          list(symbol("a"), symbol("b")),
          list(symbol("c"), symbol("d")),
          symbol("e")
        )
      )
    end

    # rubocop: disable RSpec/ExampleLength
    it "applies one car for each a in the invocation" do
      result = [
        evaler.call(invoke("cadr", quote_list), lisp),
        evaler.call(invoke("caddr", quote_list), lisp),
        evaler.call(invoke("cdar", quote_list), lisp),
      ]

      expect(result).to eq [
        list(symbol("c"), symbol("d")),
        symbol("e"),
        list(symbol("b")),
      ]
    end
    # rubocop: enable RSpec/ExampleLength

    it "returns nil if argument is an empty list" do
      ivk = invoke("caaar", invoke("quote", list))

      expect(evaler.call(ivk, lisp)).to be_nil
    end

    it "returns nil if argument is nil" do
      ivk = invoke("caaar", nil)

      expect(evaler.call(ivk, lisp)).to be_nil
    end

    it "raises if argument is not a list" do
      expect { evaler.call(invoke("caaar", "1"), lisp) }.to raise_error(
        Campa::Error::IllegalArgument,
        "Illegal argument: \"1\" was expected to be a list"
      )
    end
  end
end
