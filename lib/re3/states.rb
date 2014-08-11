module Re3
  module States
    class AcceptState; end

    class State
      attr_reader :char, :next_state

      def initialize(char, next_state)
        @char = char
        @next_state  = next_state
      end
    end

    class SplitState
      attr_reader :left, :right

      def initialize(left, right)
        @left  = left
        @right = right
      end

      def loop_left(new_left)
        @left = new_left
      end
    end
  end
end
