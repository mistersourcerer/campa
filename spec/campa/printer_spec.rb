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
end
