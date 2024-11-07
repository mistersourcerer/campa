RSpec.describe Campa::Lisp::Cond do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }
  let(:reader_class) { Campa::Reader }

  # rubocop: disable RSpec/ExampleLength
  describe "(cond ...)" do
    it "raises if argument is not a list" do
      expect { evaler.call(invoke("cond", "1"), lisp) }.to raise_error(
        Campa::Error::IllegalArgument,
        "Illegal argument: \"1\" was expected to be a list"
      )
    end

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
      ivk = invoke("cond", *conditions)

      expect(evaler.call(ivk, lisp)).to eq symbol("second")
    end

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
      ivk = invoke("cond", *conditions)

      expect(evaler.call(ivk, lisp)).to be_nil
    end

    it "returns the value of the truethy expression itself if no 'tail' is given" do
      conditions = [
        list(
          invoke("eq", invoke("quote", symbol("a")), invoke("quote", symbol("b"))),
          invoke("quote", symbol("first"))
        ),
        list(1),
      ]
      ivk = invoke("cond", *conditions)

      expect(evaler.call(ivk, lisp)).to eq 1
    end

    it "knows to evaluate conditions when first term is already evaled" do
      conditions = [
        list(false, invoke("quote", symbol("x"))),
        list(true, invoke("quote", symbol("y")))
      ]
      ivk = invoke("cond", *conditions)

      expect(evaler.call(ivk, lisp)).to eq symbol("y")
    end

    context "when there are many instructions in a truethy condition" do
      it "execut all instructions in the 'truethy' body" do
        instruction =
          "(cond ((eq 1 2) 'no) (true (label x 1) (label y 2) (label z 3) y))"
        result = evaler.eval(reader_class.new(instruction), lisp)

        expect(result).to eq 2
      end
    end
  end
  # rubocop: enable RSpec/ExampleLength
end
