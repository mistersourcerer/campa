require "stringio"

module Campa
  # rubocop: disable Metrics/ClassLength
  class Reader
    # rubocop: enable Metrics/ClassLength
    def initialize(input)
      @input =
        if input.respond_to?(:getc) && input.respond_to?(:eof?)
          input
        else
          to_io_like(input)
        end

      next_char
    end

    def next
      eat_separators
      return if @input.eof? && separator?

      read
    end

    private

    def to_io_like(input)
      # TODO: check if it is "castable" first,
      StringIO.new(input)
    end

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

    def eat_separators
      return if @input.eof?

      next_char while separator?
    end

    # rubocop: disable Metrics/MethodLength, Metrics/PerceivedComplexity, Style/EmptyCaseCondition
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
      when @current_char == "'"
        read_quotation
      when @current_char == "("
        read_list
      else
        read_symbol
      end
    end
    # rubocop: enable Metrics/MethodLength, Metrics/PerceivedComplexity, Style/EmptyCaseCondition

    def read_string
      return if @input.eof?

      string = ""
      # eats the opening "
      next_char

      while !@input.eof? && @current_char != "\""
        string << @current_char
        next_char
      end
      raise Error::MissingDelimiter, "\"" if @current_char != "\""

      # eats the closing "
      next_char

      string
    end

    def read_number
      number = @current_char
      cast = ->(str) { Integer(str) }

      until @input.eof?
        cast = ->(str) { Float(str) } if @current_char == "."
        next_char
        break if separator? || delimiter?

        number << @current_char
      end

      safe_cast(number, cast)
    end

    def safe_cast(number, cast)
      cast.call(number)
    rescue ArgumentError
      raise Error::InvalidNumber, number
    end

    def read_quotation
      # eats the ' char
      next_char

      expression = self.next
      List.new(symbol("quote"), expression)
    end

    def read_list
      # eats the opening (
      next_char

      elements = []
      while !@input.eof? && @current_char != ")"
        token = self.next
        elements << token
        eat_separators if separator?
      end
      raise Error::MissingDelimiter, ")" if @current_char != ")"

      # eats the closing )
      next_char

      List.new(*elements)
    end

    def read_symbol
      label = @current_char

      until @input.eof?
        next_char
        break if separator? || delimiter?

        label << @current_char
      end

      # TODO: validate symbol (raise if invalid chars are present)
      Symbol.new(label)
    end

    def separator?
      @current_char == "\s" || @current_char == "," || @current_char == "\n"
    end

    def delimiter?
      @current_char == ")"
    end

    def digit?(char = nil)
      char ||= @current_char
      # TODO: should we force the encoding of source files?
      #   (since codepoints will be different depending on encoding).
      !char.nil? && (char.ord >= 48 && char.ord <= 57)
    end
  end
end
