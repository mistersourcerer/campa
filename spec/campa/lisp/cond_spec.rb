RSpec.describe Campa::Lisp::Cond do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }

  describe "(cond ...)" do
    it "raises if argument is not a list" do
      expect { evaler.call(invoke("cond", "1"), lisp) }.to raise_error(
        Campa::Error::IllegalArgument,
        "Illegal argument: \"1\" was expected to be a list"
      )
    end

    # rubocop: disable RSpec/ExampleLength
    it "returns the second element besides the first truethy value" do
      conditions = [
        list(
          invoke("eq", invoke("quote", symbol("a")), invoke("quote", symbol("b"))),
          invoke("quote", symbol("first"))
        ),
        list(
          invoke("atom", invoke("quote", symbol("a"))),
          invoke("quote", symbol("second"))
        ),
      ]
      ivk = invoke("cond", list(*conditions))

      expect(evaler.call(ivk, lisp)).to eq symbol("second")
    end
    # rubocop: enable RSpec/ExampleLength

    # rubocop: disable RSpec/ExampleLength
    it "returns nil if none of the condition 'heads' eval to true" do
      conditions = [
        list(
          invoke("eq", invoke("quote", symbol("a")), invoke("quote", symbol("b"))),
          invoke("quote", symbol("first"))
        ),
        list(
          invoke("atom", invoke("quote", list(symbol("a")))),
          invoke("quote", symbol("second"))
        ),
      ]
      ivk = invoke("cond", list(*conditions))

      expect(evaler.call(ivk, lisp)).to eq nil
    end
    # rubocop: enable RSpec/ExampleLength

    # rubocop: disable RSpec/ExampleLength
    it "returns the value of the truethy expression itself if no 'tail' is given" do
      conditions = [
        list(
          invoke("eq", invoke("quote", symbol("a")), invoke("quote", symbol("b"))),
          invoke("quote", symbol("first"))
        ),
        list(1),
      ]
      ivk = invoke("cond", list(*conditions))

      expect(evaler.call(ivk, lisp)).to eq 1
    end
    # rubocop: enable RSpec/ExampleLength
  end
end
