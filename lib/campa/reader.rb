require "stringio"

module Campa
  class Reader
    SEPARATOR = /\A\s|,/
    STRING = /\A"/
    DIGIT = /\A\d/
    NUMERIC = /\A[\d_]/

    def initialize(input)
      @current_char = nil
      @input =
        if input.respond_to?(:getc) && intput.respond_to?(:eof?)
          input
        else
          to_io_like(input)
        end
    end

    def next
      eat_separators
      read
    end

    private

    def to_io_like(input)
      # TODO: check if it is "castable" first,
      StringIO.new(input)
    end

    def eat_separators
      return if @input.eof?

      @current_char = @input.getc
      @current_char = @input.getc while separator?
    end

    def read
      case
      when @current_char == "\""
        read_string
      end
    end

    def read_string
      return if @input.eof?

      string = ""
      while !@input.eof? && (char = @input.getc) != "\""
        string << char
      end
      raise Error::MissingDelimiter, "\"" if char != "\""

      # eat the close quotation mark
      @current_char = @input.getc

      string
    end

    def separator?
      @current_char == "\s" || @current_char == ","
    end
  end
end
