RSpec.describe Campa::Lisp::Car do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }

  describe "(car ...)" do
    it "returns the first element in the list" do
      ivk = invoke("car", invoke("quote", list("a", "b", "c")))

      expect(evaler.call(ivk, lisp)).to eq "a"
    end

    it "returns nil if argument is an empty list" do
      ivk = invoke("car", invoke("quote", list))

      expect(evaler.call(ivk, lisp)).to be_nil
    end

    it "returns nil if argument is nil" do
      ivk = invoke("car", nil)

      expect(evaler.call(ivk, lisp)).to be_nil
    end

    it "raises if argument is not a list" do
      expect { evaler.call(invoke("car", "1"), lisp) }.to raise_error(
        Campa::Error::IllegalArgument,
        "Illegal argument: \"1\" was expected to be a list"
      )
    end
  end
end
