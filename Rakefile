# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"
RuboCop::RakeTask.new

require "campa"
desc "executes the campa language tests"
task :campatest do
  Campa::Cli.new.execute([
    "test",
    Dir.glob(Campa.root.join("../test/**/*").to_s)
  ].flatten)
rescue SystemExit => e
  # Do not interrupt the rake execution
  # if campa tests were successfull
  exit(1) if e.status != 0
end

task default: %i[spec campatest rubocop]
