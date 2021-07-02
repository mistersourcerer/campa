# frozen_string_literal: true

require_relative "campa/version"
require "zeitwerk"

module Campa
  CR_REGEX = /\Ac(a|d)+r$/
end

loader = Zeitwerk::Loader.for_gem
loader.setup
