RSpec.describe Campa::Printer do
  subject(:printer) { described_class.new }

  context "when printing string" do
    it "returns the 'quoted' string" do
      expect(printer.call("bbq")).to eq "\"bbq\""
    end
  end

  context "when printing symbols" do
    it "returns the symbol's label" do
      expect(printer.call(symbol("a"))).to eq "a"
    end
  end

  context "when outputing lists" do
    it "returns the construction form for the list" do
      expect(printer.call(list(1, 2, 3))).to eq "(1 2 3)"
    end

    it "formats the list elements too" do
      to_print = list(1, "2", list(symbol("three"), 4.2), true, false)

      expect(printer.call(to_print)).to eq "(1 \"2\" (three 4.2) true false)"
    end
  end

  context "when outputing lambdas" do
    it "outputs the creation instruction for the lambda" do
      to_print =
        Campa::Lambda.new(list, [invoke("label", symbol("x"), 4.20), symbol("x")])

      expect(printer.call(to_print)).to eq "(lambda () (label x 4.2) x)"
    end
  end

  context "when outputing contexts" do
    # rubocop: disable RSpec/ExampleLength
    it "show fallbacks idented in relation to current context" do
      first = Campa::Context.new(symbol("z") => symbol("a"))
      fallback = first.push Campa::Context.new(symbol("z") => symbol("b"))
      to_print = fallback.push Campa::Context.new(
        symbol("lol") => symbol("bbq"),
        symbol("time") => 420
      )

      expect(printer.call(to_print))
        .to eq "lol: bbq\ntime: 420\n  z: b\n    z: a"
    end
    # rubocop: enable RSpec/ExampleLength
  end
end
