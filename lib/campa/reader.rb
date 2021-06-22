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

    def next_char
      if @next_char.nil?
        @current_char = @input.getc
      else
        @current_char = @next_char
        @next_char = nil
      end

      @current_char
    end

    def peek
      return @next_char if !@next_char.nil?

      @next_char = @input.getc
    end

    def to_io_like(input)
      # TODO: check if it is "castable" first,
      StringIO.new(input)
    end

    def eat_separators
      return if @input.eof?

      next_char
      next_char while separator?
    end

    def read
      case
      when @current_char == "\""
        read_string
      when digit?
        read_number
      when @current_char == "-"
        if digit?(peek)
          read_number
        else
          read_symbol
        end
      else
        read_symbol
      end
    end

    def read_string
      return if @input.eof?

      string = ""
      while !@input.eof? && next_char != "\""
        string << @current_char
      end
      raise Error::MissingDelimiter, "\"" if @current_char != "\""

      # eat the close quotation mark
      next_char

      string
    end

    def read_number
      number = ""
      cast = ->(str) { Integer(str) }

      while !@input.eof? && !separator?
        number << @current_char
        cast = ->(str) { Float(str) } if @current_char == "."
        next_char
      end

      # If number was the last thing in the input
      #   we hit the #eof? before having the chance
      #   to concatenate the last digit of it
      number << @current_char if digit?

      begin
        cast.call(number)
      rescue ArgumentError
        raise Error::InvalidNumber, number
      end
    end

    def read_symbol
      label = @current_char

      while !@input.eof?
        next_char
        break if separator?
        label << @current_char
      end

      # TODO: validate symbol (raise if invalid chars are present)
      Symbol.new(label)
    end

    def separator?
      @current_char == "\s" || @current_char == ","
    end

    def digit?(char = nil)
      char ||= @current_char
      # TODO: should we force the encoding of source files?
      #   (since codepoints will be different depending on encoding).
      !char.nil? && (char.ord >= 48 && char.ord <= 57)
    end
  end
end
