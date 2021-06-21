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
          Campa::Error::MissingDelimiter,
          "\" was expected but none was found"
        )
      end
    end

    context "when reading numbers" do
      it "recognizes integers" do
        expect(new_reader("4").next).to eq 4
      end

      it "recognizes floats" do
        expect(new_reader("4.2").next).to eq 4.2
      end

      it "recongnizes negatives" do
        expect(new_reader("-4.2").next).to eq -4.2
      end

      it "raises when number is invalid" do
        expect { new_reader("4and20").next }.to raise_error(
          Campa::Error::InvalidNumber,
          "Invalid number: 4and20"
        )
      end
    end

    context "when reading primitives" do
      it "reads symbols" do
        pending
        expect(new_reader("lol").next).to eq symbol("lol")
      end
    end

    it "reads invocations into lists"
    it "understands the ' for quoting"
  end
end
