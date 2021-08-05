# frozen_string_literal: true

require_relative "campa/version"
require "pathname"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

# Campa is a tiny LISP implementation.
#
# The "benchmark" for this is to cover the specification
# established by the Paul Graham's article
# {http://paulgraham.com/rootsoflisp.html The Roots of Lisp}.
#
# So the following functions are implemented
# in the runtime:
#
#   - (atom something)
#   - (car list)
#   - (cdr list)
#   - (cond (some-condition value) (another-condition another-value))
#   - (cons 'first '(second third))
#   - (defun fun-name (parameters list) 'body)
#   - (eq a-thing another-thing)
#   - (label meaning-of-life 42)
#   - (quote (some stuff))
#
# Besides these core functions
# other two ones,
# also specified on The Roots of Lisp,
# are also implemented on tnis LISP:
#
#   - (cadr list) - and any variation possible (caaar, cadadar...)
#   - (list 'this 'creates 'a 'new 'list)
#
# Those are all the functions necessary
# to implement an eval function
# able to interprete LISP by itself.
#
# And to be sure that this is the case
# we have this implementation on {file:campa/core.cmp campa/core.cmp}.
module Campa
  # caar, cddr, cadr, but not car or cdr
  CR_REGEX = /\Ac((ad)|(a|d){2,})r$$/

  # symbol to reference the "stdout" in a Campa execution context
  SYMBOL_OUT = Symbol.new("__out__")

  # symbol for the lambda function
  SYMBOL_LAMBDA = Symbol.new("lambda")

  # symbol for the quote function
  SYMBOL_QUOTE = Symbol.new("quote")

  # Returns a Pathname pointint to
  # the root of the "gem".
  #
  # Useful for requiring and/or finding files
  # that need to be read by the runtime.
  def self.root
    @root ||= Pathname.new File.expand_path(__dir__)
  end
end
