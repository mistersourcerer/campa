# frozen_string_literal: true

require_relative "campa/version"
require "zeitwerk"

module Campa
  class Error < StandardError; end
  # Your code goes here...
end

loader = Zeitwerk::Loader.for_gem
loader.setup
