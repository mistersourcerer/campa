# frozen_string_literal: true

require "campa"
Bundler.require :default

# rubocop:disable Lint/SuppressedException
begin
  require "simplecov"

  # https://github.com/simplecov-ruby/simplecov#running-simplecov-against-subprocesses
  SimpleCov.enable_for_subprocesses true
  SimpleCov.at_fork do |pid|
    # This needs a unique name so it won't be ovewritten
    SimpleCov.command_name "#{SimpleCov.command_name} (subprocess: #{pid})"
    # be quiet, the parent process will be in charge of output and checking coverage totals
    SimpleCov.print_error_status = false
    SimpleCov.formatter SimpleCov::Formatter::SimpleFormatter
    SimpleCov.minimum_coverage 0
    # start
    SimpleCov.start
  end

  SimpleCov.start do
    # After enabling simplecov for subprocesses
    # it seems like the results were "accumulating" somehow.
    # This is a very Hacky solution.
    # TODO: find why this is happening and if possible fix it.
    FileUtils.rm_rf Campa.root.join("../coverage").to_s

    add_filter %r{^/spec/}
  end
rescue LoadError
end
# rubocop:enable Lint/SuppressedException

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def symbol(label)
    Campa::Symbol.new(label)
  end

  def list(*args)
    Campa::List.new(*args)
  end

  def invoke(label, *params)
    list(symbol(label), *params)
  end
end
