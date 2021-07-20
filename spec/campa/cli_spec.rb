RSpec.describe Campa::Cli do
  subject(:cli) { described_class.new(repl: repl) }

  let(:repl) { instance_spy("Campa::Repl") }
  let(:file) { Campa.root.join("../spec/exec_example.cmp").to_s }
  let(:process_out) do
    Class.new do
      def initialize(wrt)
        @wrt = wrt
      end

      def print(thing)
        @wrt.write thing
      end

      def puts(thing)
        @wrt.write "#{thing}\n"
      end
    end
  end

  def execute_in_process(options)
    rd, wrt = IO.pipe
    out = process_out.new(wrt)
    Process.wait(
      Process.fork do
        rd.close
        block_given? ? yield(out) : cli.execute(options, out: out)
      end
    )
    wrt.close

    rd
  end

  context "when no parameters (ARGV) are given" do
    it "calls the repl if no arg is given" do
      cli.execute

      expect(repl).to have_received(:run).with($stdin, $stdout)
    end

    it "calls the repl if arg (ARGV) is empty" do
      cli.execute([])

      expect(repl).to have_received(:run).with($stdin, $stdout)
    end

    it "ensures actual repl is being called" do
      rd = execute_in_process([]) do |out|
        described_class.new.execute(input: StringIO.new("\n"), out: out)
      end

      expect(rd.read).to eq "=> "
    end
  end

  context "when first argument is an existent file" do
    it "evaluates file as a campa source code file" do
      rd = execute_in_process([file])

      expect(rd.read).to eq "hello"
    end

    it "exists after evaluating" do
      execute_in_process([file])

      expect(Process.last_status.exitstatus).to eq 0
    end
  end

  context "when executing options" do
    it "executes the repl if option given is unknown" do
      expect { cli.execute(["omg-this_will_never-be-an_option"]) }
        .to raise_error("Unknown option omg-this_will_never-be-an_option")
    end

    describe ":test" do
      let(:file_with_failure) do
        Campa.root.join("../spec/exec_example_failure.cmp").to_s
      end

      it "executes tests available on files" do
        rd = execute_in_process(["test", file])

        # first line is the print from the example function
        # second is an empty line printed by the reporter
        expect(rd.read.split("\n")[2]).to eq "1 tests ran"
      end

      it "exists with 0 if all tests pass" do
        execute_in_process(["test", file])

        expect(Process.last_status.exitstatus).to eq 0
      end

      it "exists with 1 if any test fail" do
        execute_in_process(["test", file_with_failure])

        expect(Process.last_status.exitstatus).to eq 1
      end
    end
  end
end
