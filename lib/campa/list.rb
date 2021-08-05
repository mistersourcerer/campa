module Campa
  # A minimalist implementation of a Linked List.
  #
  # An instance of it represents a function ivocation
  # in the context of a {Evaler#call} or a {Evaler#eval} call.
  #
  # The importance of adding the adjective <i>"minimalist"</i>
  # in this description
  # is to give already the idea that this implementation
  # does not come with some algorithms (deleting, for example)
  # since for this also minimal Lisp implementation
  # this won't be necessary.
  class List
    include Enumerable

    EMPTY = new

    # @param elements [Array<Object>] elements linked on the current {List}
    def initialize(*elements)
      @first = nil
      @head = nil
      @tail = EMPTY

      with elements
    end

    # Creates a new {List} with the parameter passed
    # in front of it.
    #
    # @example
    #   List.new(2, 3).push(1) #=> List.new(1, 2, 3)
    #
    # @param element [Object] any thing to be pushed into the {List}
    # @return [List] new {List} with new element in front of it
    def push(element)
      self.class.new.tap do |l|
        l.first = Node.new(value: element, next_node: first)
      end
    end

    # First element of the current {List}.
    #
    # Return <i>nil</i> if the current list is {EMPTY}.
    #
    # @return [Object, nil]
    def head
      return nil if self == EMPTY

      first.value
    end

    # Creates a new list
    # with all elements of the current one BUT the head.
    #
    # @example
    #   List.new(1, 2, 3).tail #=> List.new(2, 3)
    #
    # @return [List] with the "rest" of the elements on this {List}
    def tail
      return EMPTY if first.nil? || first.next_node.nil?

      self.class.new.tap { |l| l.first = @first.next_node }
    end

    # Yields each element starting from head.
    def each(&block)
      return if self == EMPTY

      block.call(head)
      tail.each(&block) if tail != EMPTY
    end

    # Stablishes equality by comparing each element in the {List}.
    #
    #
    # @param other [List] to be compared
    # @return [Boolean] <b>true</b> if of both {List} have equal (<i>#==</i>) elements
    def ==(other)
      return false if !other.is_a?(List)

      node = first
      other_node = other.first

      loop do
        # If both node and other_node are nil
        # we managed to walk the whole list.
        # Since there was no early return (with false)
        # this means all nodes are equal.
        return node.nil? if other_node.nil?
        return false if node != other_node

        node = node.next_node
        other_node = other_node.next_node
      end
    end

    # Uses {Printer} to represent the current {List}
    # in a human readable form.
    #
    # @example
    #   List.new(1, 2, 3).inspect #=> "(1 2 3)"
    def inspect
      @printer ||= Printer.new
      @printer.call(self)
    end

    protected

    attr_accessor :first

    private

    def with(elements)
      return if elements.empty?

      elements.reduce(nil) do |previous, current|
        new_node = Node.new(value: current)
        if previous.nil?
          self.first = new_node
        else
          previous.next_node = new_node
        end
      end
    end
  end
end
