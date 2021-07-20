RSpec.describe Campa::Core::Test do
  subject(:test) { described_class.new }

  let(:evaler) { Campa::Evaler.new }
  let(:ctx) { Campa::Language.new.push Campa::Context.new }
  let(:result) { test.call(env: ctx) }
  let(:tests) do
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
    evaler.eval(tests, ctx)
  end

  def filter_results(result, type)
    result
      .to_a
      .find { |l| l.head.label == type }
      .tail.head.to_a
      .map(&:label)
  end

  context "when collecting results" do
    it "knows all succeeded tests in the current context" do
      expect(filter_results(result, "success"))
        .to eq %w[test-one test-two test-three test-four]
    end

    it "knows all failed tests in the current context" do
      expect(filter_results(result, "failures"))
        .to eq %w[test-fail-one test-fail-two]
    end

    it "considers a function that raises a failure" do
      ctx[symbol("test-one")] = ->(_, _) { raise "oh no!" }

      expect(filter_results(result, "failures"))
        .to eq %w[test-one test-fail-one test-fail-two]
    end
  end

  describe "(tests-run ...)" do
    it "run all tests in the current context" do
      result = evaler.call(invoke("tests-run"), ctx)
      all = %w[success failures].map { |t| filter_results(result, t) }.flatten

      expect(all).to match_array %w[
        test-one test-two test-three test-four test-fail-one test-fail-two
      ]
    end

    it "executes only given tests (by name)" do
      result = evaler.call(invoke("tests-run", "one", "fail-one"), ctx)
      all = %w[success failures].map { |t| filter_results(result, t) }.flatten

      expect(all).to match_array %w[test-one test-fail-one]
    end
  end
end
