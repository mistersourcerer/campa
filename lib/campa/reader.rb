require "stringio"

module Campa
  # rubocop: disable Metrics/ClassLength
  class Reader
    # rubocop: enable Metrics/ClassLength
    def initialize(input)
      @input = to_io_like(input)
      next_char
    end

    def next
      eat_separators
      return read if !@input.eof?
      return if @current_char.nil?

      # Exhaust the reader if @input.eof? and !@current_char.nil?
      next_token = read
      @current_char = nil
      next_token
    end

    private

    SEPARATORS = ["\s", ","].freeze
    BOOLS = %w[true false].freeze
    CAST_INT = ->(str) { Integer(str) }
    CAST_FLOAT = ->(str) { Float(str) }
    SYM_QUOTE = Symbol.new("quote")

    def to_io_like(input)
      return input if input.respond_to?(:getc) && input.respond_to?(:eof?)
      return File.new(input) if File.exist?(input)

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
      if @input.eof?
        @current_char = nil if separator? || break?
        return
      end

      next_char while separator? || break?
    end

    # rubocop: disable Metrics/MethodLength, Metrics/PerceivedComplexity
    # rubocop: disable Style/EmptyCaseCondition
    # rubocop: disable Metrics/CyclomaticComplexity
    def read
      case
      when @current_char == "\""
        read_string
      when digit? || @current_char == "-" && digit?(peek)
        read_number
      when @current_char == "'"
        read_quotation
      when @current_char == "("
        read_list
      when boolean?
        read_boolean
      else
        read_symbol
      end
    end
    # rubocop: enable Metrics/MethodLength, Metrics/PerceivedComplexity
    # rubocop: enable Style/EmptyCaseCondition
    # rubocop: enable Metrics/CyclomaticComplexity

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
      cast = CAST_INT

      until @input.eof?
        cast = CAST_FLOAT if @current_char == "."
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

      List.new(SYM_QUOTE, expression)
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

    def read_boolean
      boolean_value = @current_token
      @current_token = nil
      next_char
      boolean_value == "true"
    end

    def read_symbol
      label = @current_token || @current_char
      @current_token = nil

      until @input.eof?
        next_char
        break if separator? || delimiter? || break?

        label << @current_char
      end

      # TODO: validate symbol (raise if invalid chars are present)
      Symbol.new(label)
    end

    def separator?
      SEPARATORS.include? @current_char
    end

    def break?
      @current_char == "\n"
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

    def boolean?
      return false if @current_char != "t" && @current_char != "f"

      @current_token = @current_char
      @current_token << next_char until @input.eof? || peek == " " || peek == ")"
      BOOLS.include? @current_token
    end
  end
end
