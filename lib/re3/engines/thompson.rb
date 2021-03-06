require 'set'

module Re3
  module Engines
    class ThompsonEngine
      include States

      def initialize(nodes, input)
        @input = input
        @current_states = expand(nodes.compile_nfa)
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

      def expand(state, visited = Set.new)
        return Set.new if visited.include? state
        visited << state

        case state
        when SplitState
          expand(state.left, visited) + expand(state.right, visited)
        when CharState, AcceptState
          [state].to_set
        end
      end
    end
  end
end
