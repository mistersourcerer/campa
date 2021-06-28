RSpec.describe Campa::Lisp::Cons do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }

  describe "(cons ...)" do
    it "returns a new list with with the given head in front of it" do
      the_list = invoke("quote", list(symbol("b"), symbol("c")))
      ivk = invoke("cons", invoke("quote", symbol("a")), the_list)

      expect(evaler.call(ivk, lisp)).to eq list(symbol("a"), symbol("a"), symbol("a"))
    end

    it "raises if argument is not a list" do
      expect { evaler.call(invoke("cons", "a", "1"), lisp) }.to raise_error(
        Campa::Error::IllegalArgument,
        "Illegal argument: \"1\" was expected to be a list"
      )
    end
  end
end
