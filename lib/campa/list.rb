module Campa
  class List
    include Enumerable

    EMPTY = new

    def initialize(*elements)
      @first = nil
      @head = nil
      @tail = EMPTY

      with elements
    end

    def push(element)
      self.class.new.tap do |l|
        l.first = Node.new(value: element, next_node: first)
      end
    end

    def head
      return nil if self == EMPTY

      first.value
    end

    def tail
      return EMPTY if first.nil? || first.next_node.nil?

      self.class.new.tap { |l| l.first = @first.next_node }
    end

    def each(&block)
      return if self == EMPTY

      block.call(head)
      tail.each(&block) if tail != EMPTY
    end

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
