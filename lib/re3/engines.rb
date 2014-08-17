module Re3
  module Engines
    class ThompsonEngine
      def initialize(regexp, input)
        @input  = input
        @current_states = regexp.start_state.expand.to_set
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
          state.next_states_for(c)
        end.flatten.to_set
      end
    end
  end
end
