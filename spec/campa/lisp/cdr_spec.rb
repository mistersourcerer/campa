RSpec.describe Campa::Lisp::Cdr do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }

  describe "(cdr ...)" do
    it "returns the rest of the list" do
      ivk = invoke("cdr", invoke("quote", list("a", "b", "c")))

      expect(evaler.call(ivk, lisp)).to eq list("b", "c")
    end

    it "doesn't break if the list has only two elements" do
      ivk = invoke("cdr", invoke("quote", list("a", list("b", "c"))))

      expect(evaler.call(ivk, lisp)).to eq list(list("b", "c"))
    end

    it "returns nil if argument is an empty list" do
      ivk = invoke("cdr", invoke("quote", list))

      expect(evaler.call(ivk, lisp)).to eq nil
    end

    it "returns nil if argument is nil" do
      ivk = invoke("cdr", nil)

      expect(evaler.call(ivk, lisp)).to eq nil
    end

    it "raises if argument is not a list" do
      expect { evaler.call(invoke("cdr", "1"), lisp) }.to raise_error(
        Campa::Error::IllegalArgument,
        "Illegal argument: \"1\" was expected to be a list"
      )
    end
  end
end
