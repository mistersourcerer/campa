RSpec.describe Campa::Reader do
  def new_reader(input)
    described_class.new(input)
  end

  describe "#next" do
    context "when reading strings" do
      it "reads strings" do
        expect(new_reader("\"lol\"").next).to eq "lol"
      end

      it "knows when a string is finished" do
        reader = new_reader("\"l o l\" , \" bbq \"")

        expect([reader.next, reader.next]).to eq ["l o l", " bbq "]
      end

      it "raises if a string is not closed" do
        expect { new_reader("\"lol").next }.to raise_error(
          Campa::MissingDelimiterError,
          "\" was expected but none was found"
        )
      end
    end

    context "when reading primitives" do
      it "reads symbols" do
        pending
        expect(new_reader("lol").next).to eq symbol("lol")
      end

      it "reads numbers" do
        pending
        expect(new_reader("4").next).to eq 4
      end
    end

    it "reads invocations into lists"
    it "understands the ' for quoting"
  end
end
