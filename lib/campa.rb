# frozen_string_literal: true

require_relative "campa/version"
require "zeitwerk"

module Campa
  CR_REGEX = /\Ac((ad)|(a|d){2,})r$$/ # caar, cddr, cadr, but not car or cdr
end

loader = Zeitwerk::Loader.for_gem
loader.setup
