require 're3/states'

module Re3
  module Nodes
    class Unary
      include States

      def initialize(child)
        @child = child
      end
    end

    class Binary
      include States

      def initialize(left, right)
        @left  = left
        @right = right
      end
    end

    class Char < Unary
      def compile(next_state = AcceptState.new)
        State.new(@child, next_state)
      end

      def to_s
        @child.to_s
      end
    end

    class Or < Binary
      def compile(next_state = AcceptState.new)
        SplitState.new(@left.compile(next_state), @right.compile(next_state))
      end

      def to_s
        "#{@left}|#{@right}"
      end
    end

    class And < Binary
      def compile(next_state = AcceptState.new)
        @left.compile(@right.compile(next_state))
      end

      def to_s
        "#{@left}#{@right}"
      end
    end

    class Any < Unary
      def compile(next_state = AcceptState.new)
        res = SplitState.new(nil, next_state)
        res.loop_left(@child.compile(res))

        res
      end

      def to_s
        "#{@child}*"
      end
    end

    class Maybe < Unary
      def compile(next_state = AcceptState.new)
        SplitState.new(@child.compile(next_state), next_state)
      end

      def to_s
        "#{@child}?"
      end
    end

    class AtLeastOne < Unary
      def compile(next_state = AcceptState.new)
        split = SplitState.new(nil, next_state)
        res = @child.compile(split)
        split.loop_left(res)

        res
      end

      def to_s
        "#{@child}+"
      end
    end

    class Group < Unary
      def compile(next_state = AcceptState.new)
        @child.compile(next_state)
      end

      def to_s
        "(#{@child})"
      end
    end
  end
end
