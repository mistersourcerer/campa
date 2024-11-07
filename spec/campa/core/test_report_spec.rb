RSpec.describe Campa::Core::Test do
  subject(:test) { described_class.new }

  let(:evaler) { Campa::Evaler.new }
  let(:ctx) { Campa::Language.new.push Campa::Context.new }
  let(:output) { StringIO.new }

  let(:success) do
    Campa::Reader.new(<<~T)
      (defun test-one () true)
      (defun test-two () true)
      (defun test-three () true)
      (defun test-four () true)
    T
  end

  let(:failures) do
    Campa::Reader.new(<<~T)
      (defun test-one () true)
      (defun test-two () true)
      (defun test-three () true)
      (defun test-fail-one () false)
      (defun test-fail-two () false)
      (defun test-four () true)
    T
  end

  before do
    ctx[symbol("__out__")] = output
  end

  # rubocop: disable RSpec/MultipleMemoizedHelpers
  describe "(tests-report (test-run))" do
    before do
      run_test
    end

    let!(:result) do
      evaler.call(invoke("tests-report", invoke("tests-run")), ctx)
    end

    context "when all tests are successful" do
      let(:run_test) { evaler.eval(success, ctx) }

      it "outputs the success summary correctly" do
        expect(output.string.split("\n")).to eq [
          "", "", # we start by giving a 2 line buffer from whatever was there
          "4 tests ran",
          "Success: none of those returned false"
        ]
      end

      it "returns true if no tests fail" do
        expect(result).to be true
      end
    end

    context "when some tests are failures" do
      let(:run_test) { evaler.eval(failures, ctx) }

      # rubocop: disable RSpec/ExampleLength
      it "outputs the failures summary correctly" do
        expect(output.string.split("\n")).to eq [
          "", "",
          "6 tests ran", "FAIL!",
          "  2 tests failed",
          "  they are:",
          "    - test-fail-one",
          "    - test-fail-two"
        ]
      end
      # rubocop: enable RSpec/ExampleLength

      it "returns false if there are any failures" do
        expect(result).to be false
      end
    end
  end
  # rubocop: enable RSpec/MultipleMemoizedHelpers
end
