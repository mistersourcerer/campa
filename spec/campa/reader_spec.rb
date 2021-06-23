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
        expect(new_reader("-4.2").next).to eq(-4.2)
      end

      it "raises when number is invalid" do
        expect { new_reader("4and20").next }.to raise_error(
          Campa::Error::InvalidNumber,
          "Invalid number: 4and20"
        )
      end
    end

    context "when reading symbols" do
      it "returns the symbol object" do
        expect(new_reader("lol").next).to eq symbol("lol")
      end

      it "knows when a symbol declaration finishes" do
        reader = new_reader("lol b-b-q")
        expect([reader.next, reader.next])
          .to eq [symbol("lol"), symbol("b-b-q")]
      end

      it "does not go crazy when symbol starts with hiphen" do
        expect(new_reader("-bbq").next).to eq symbol("-bbq")
      end
    end

    context "when reading bools" do
      it "read 'true' and 'false' as booleans" do
        reader = new_reader("true false")

        expect([reader.next, reader.next]).to eq [true, false]
      end

      it "does not break logic for symbols starting with true or false" do
        reader = new_reader("truethy falsey")

        expect([reader.next, reader.next])
          .to eq [symbol("truethy"), symbol("falsey")]
      end

      it "does not break te overall multiple expressions logic" do
        reader = new_reader("true false true '(a b)")
        3.times { reader.next }

        expect(reader.next)
          .to eq list(symbol("quote"), list(symbol("a"), symbol("b")))
      end
    end

    context "when reading lists" do
      it "reads invocations into lists" do
        expect(new_reader("(bbq \"yas\")").next)
          .to eq list(symbol("bbq"), "yas")
      end

      it "reads invocations into lists with multiple args" do
        expect(new_reader("(bbq 1 \"two\" 3.0)").next)
          .to eq list(symbol("bbq"), 1, "two", 3.0)
      end

      it "knows awfully formatted lists" do
        expect(new_reader("(  bbq 1 \"two\" 3.0 )").next)
          .to eq list(symbol("bbq"), 1, "two", 3.0)
      end

      # rubocop: disable RSpec/ExampleLength
      it "knows how to read multiple lists" do
        reader = new_reader("(bbq 1) (time 4.20) (next \"action\" )")

        expect([reader.next, reader.next, reader.next])
          .to eq [
            list(symbol("bbq"), 1),
            list(symbol("time"), 4.20),
            list(symbol("next"), "action")
          ]
      end
      # rubocop: enable RSpec/ExampleLength
    end

    context "when quoting" do
      it "understands the ' for quoting" do
        expect(new_reader("'q").next)
          .to eq list(symbol("quote"), symbol("q"))
      end

      # rubocop: disable RSpec/ExampleLength
      it "knows how to read multiple quotes" do
        reader = new_reader(" 'q 'z ")

        expect([reader.next, reader.next])
          .to eq [
            list(symbol("quote"), symbol("q")),
            list(symbol("quote"), symbol("z")),
          ]
      end
      # rubocop: enable RSpec/ExampleLength
    end

    context "when handling new lines" do
      it "handles it as a normal separator" do
        expect(new_reader("1\n").next).to eq 1
      end

      it "understands it can separate multiple expressions" do
        reader = new_reader("1\n \"two\" \n (three 4)\n ")

        expect([reader.next, reader.next, reader.next])
          .to eq [1, "two", list(symbol("three"), 4)]
      end

      it "ensures separators at the end of the input are ignored" do
        reader = new_reader("1\n")
        expect([reader.next, reader.next]).to eq [1, nil]
      end
    end
  end
end
