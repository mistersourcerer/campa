# frozen_string_literal: true

require_relative "campa/version"
require "pathname"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module Campa
  CR_REGEX = /\Ac((ad)|(a|d){2,})r$$/ # caar, cddr, cadr, but not car or cdr
  SYMBOL_OUT = Symbol.new("__out__")
  SYMBOL_LAMBDA = Symbol.new("lambda")
  SYMBOL_QUOTE = Symbol.new("quote")

  def self.root
    @root ||= Pathname.new File.expand_path(__dir__)
  end
end
