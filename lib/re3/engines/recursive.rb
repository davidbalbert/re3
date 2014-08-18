module Re3
  module Engines
    class RecursiveEngine
      include States

      def initialize(regexp, input)
        @input = input
        @start_state = regexp.start_state
      end

      def match
        match_state(@input, @start_state)
      end

      private

      def match_state(input, state)
        case state
        when CharState
          if input[0] == state.char
            match_state(input[1..-1], state.next_state)
          else
            false
          end
        when SplitState
          match_state(input, state.left) || match_state(input, state.right)
        when AcceptState
          if input.empty?
            true
          else
            false
          end
        end
      end
    end
  end
end
