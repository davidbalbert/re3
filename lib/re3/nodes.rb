require 're3/nfa'

module Re3
  module Nodes
    class Char
      def initialize(value)
        @value = value
      end

      def compile(next_state = NFA::AcceptState.new)
        NFA::State.new(@value, next_state)
      end

      def to_s
        @value.to_s
      end
    end

    class Or
      def initialize(left, right)
        @left  = left
        @right = right
      end

      def compile(next_state = NFA::AcceptState.new)
        NFA::SplitState.new(@left.compile(next_state), @right.compile(next_state))
      end

      def to_s
        "#{@left}|#{@right}"
      end
    end

    class And
      def initialize(left, right)
        @left  = left
        @right = right
      end

      def compile(next_state = NFA::AcceptState.new)
        @left.compile(@right.compile(next_state))
      end

      def to_s
        "#{@left}#{@right}"
      end
    end

    class Any
      def initialize(child)
        @child = child
      end

      def compile(next_state = NFA::AcceptState.new)
        res = NFA::SplitState.new(nil, next_state)
        res.loop_left(@child.compile(res))

        res
      end

      def to_s
        "#{@child}*"
      end
    end

    class Maybe
      def initialize(child)
        @child = child
      end

      def compile(next_state = NFA::AcceptState.new)
        NFA::SplitState.new(@child.compile(next_state), next_state)
      end

      def to_s
        "#{@child}?"
      end
    end

    class AtLeastOne
      def initialize(child)
        @child = child
      end

      def compile(next_state = NFA::AcceptState.new)
        split = NFA::SplitState.new(nil, next_state)
        res = @child.compile(split)
        split.loop_left(res)

        res
      end

      def to_s
        "#{@child}+"
      end
    end

    class Group
      def initialize(child)
        @child = child
      end

      def compile
        @child.compile
      end

      def to_s
        "(#{@child})"
      end
    end
  end
end
