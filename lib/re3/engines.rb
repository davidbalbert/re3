require 'set'

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

    class ThompsonEngine
      include States

      def initialize(regexp, input)
        @input  = input
        @current_states = expand(regexp.start_state)
      end

      def match
        @input.each_char do |c|
          step(c)
        end

        @current_states.any?(&:accepts?)
      end

      private
      def step(c)
        @current_states = @current_states.map do |state|
          next_states_for(state, c)
        end.reduce(Set.new, :+)
      end

      def next_states_for(state, c)
        case state
        when CharState
          if c == state.char
            expand(state.next_state)
          else
            Set.new
          end
        when AcceptState
          Set.new
        when SplitState
          raise "Shouldn't get here. SplitStates don't work with next_states_for."
        end
      end

      def expand(state)
        case state
        when SplitState
          expand(state.left) + expand(state.right)
        when CharState, AcceptState
          [state].to_set
        end
      end
    end
  end
end
