# frozen_string_literal: true

require "campa"
Bundler.require :default

# rubocop:disable Lint/SuppressedException
begin
  require "simplecov"
  SimpleCov.start
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
end
