RSpec.describe Campa::List do
  let(:empty) { described_class::EMPTY }

  describe ".new" do
    # rubocop:disable RSpec/ExampleLength
    it "creates a linked list with the given elements" do
      list = described_class.new(1, 2, 3, 4, 5)
      expectations = [
        list.head,
        list.tail.head,
        list.tail.tail.head,
        list.tail.tail.tail.head,
        list.tail.tail.tail.tail.head,
        list.tail.tail.tail.tail.tail
      ]

      expect(expectations).to match_array [1, 2, 3, 4, 5, empty]
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe "#push" do
    context "when list is empty" do
      subject(:list) { described_class.new }

      it "returns a list with given element in the head" do
        expect(list.push(1).head).to eq 1
      end

      it "returns a list with empty tail" do
        expect(list.push(1).tail).to eq empty
      end
    end

    context "when list has elements" do
      subject(:list) { described_class.new.push(4).push(3).push(2) }

      it "returns list with given element in front of it" do
        new_list = list.push(1)

        expect(new_list.head).to eq 1
      end

      it "ensures tail points to previous list" do
        new_list = list.push(1)

        expect(new_list.tail).to eq described_class.new(2, 3, 4)
      end
    end
  end

  describe "#to_a" do
    it "returns the list as an Array" do
      expect(described_class.new(1, 2, 3, 4).to_a).to eq [1, 2, 3, 4]
    end

    it "returns an empty Array for empty lists" do
      expect(empty.to_a).to eq []
    end
  end
end
