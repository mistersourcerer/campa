RSpec.describe Campa::Lisp::ListFn do
  let(:lisp) { Campa::Lisp::Core.new }
  let(:evaler) { Campa::Evaler.new }

  describe "(list ...)" do
    it "join all elements in a single list" do
      ivk = invoke("list", "a", "b", "c", invoke("quote", list("d", "e")))

      expect(evaler.call(ivk, lisp)).to eq list("a", "b", "c", list("d", "e"))
    end
  end
end
