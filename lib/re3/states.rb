module Re3
  module States
    class AcceptState
      def next_states_for(c)
        []
      end

      def accepts?
        true
      end
    end

    class State
      attr_reader :char, :next_state

      def initialize(char, next_state)
        @char = char
        @next_state  = next_state
      end

      def next_states_for(c)
        if c == char
          [next_state]
        else
          []
        end
      end

      def accepts?
        false
      end
    end

    class SplitState
      attr_reader :left, :right

      def initialize(left, right)
        @left  = left
        @right = right
      end

      def next_states_for(c)
        left.next_states_for(c) + right.next_states_for(c)
      end

      def accepts?
        false
      end

      def loop_left(new_left)
        @left = new_left
      end
    end
  end
end
