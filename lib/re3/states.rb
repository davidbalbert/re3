module Re3
  module States
    class State
      def accepts?
        false
      end
    end

    class AcceptState < State
      def expand
        [self]
      end

      def next_states_for(c)
        []
      end

      def accepts?
        true
      end
    end

    class CharState < State
      attr_reader :char, :next_state

      def initialize(char, next_state)
        @char = char
        @next_state  = next_state
      end

      def expand
        [self]
      end

      def next_states_for(c)
        if c == char
          next_state.expand
        else
          []
        end
      end
    end

    class SplitState < State
      attr_reader :left, :right

      def initialize(left, right)
        @left  = left
        @right = right
      end

      def expand
        left.expand + right.expand
      end

      def loop_left(new_left)
        @left = new_left
      end
    end
  end
end
