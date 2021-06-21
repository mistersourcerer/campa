# frozen_string_literal: true

require_relative "campa/version"
require "zeitwerk"

module Campa; end

loader = Zeitwerk::Loader.for_gem
loader.setup
