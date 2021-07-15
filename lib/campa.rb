# frozen_string_literal: true

require_relative "campa/version"
require "zeitwerk"

module Campa
  CR_REGEX = /\Ac((ad)|(a|d){2,})r$$/ # caar, cddr, cadr, but not car or cdr

  def self.root
    @root ||= Pathname.new File.expand_path(__dir__)
  end
end

loader = Zeitwerk::Loader.for_gem
loader.setup
