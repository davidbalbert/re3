require 're3/states'
require 're3/vm_instructions'

module Re3
  module Nodes
    class Node
      include States

      InstructionSequence = VmInstructions::InstructionSequence
    end

    class Unary < Node
      def initialize(child)
        @child = child
      end
    end

    class Binary < Node
      def initialize(left, right)
        @left  = left
        @right = right
      end
    end

    class Char < Unary
      def compile_nfa(next_state = AcceptState.new)
        CharState.new(@child, next_state)
      end

      def compile_vm_instructions(following_instructions = InstructionSequence.match)
        InstructionSequence.char(@child) + following_instructions
      end

      def to_s
        @child.to_s
      end
    end

    class Or < Binary
      def compile_nfa(next_state = AcceptState.new)
        SplitState.new(@left.compile_nfa(next_state), @right.compile_nfa(next_state))
      end

      def compile_vm_instructions(following_instructions = InstructionSequence.match)
        right_instructions = @right.compile_vm_instructions(InstructionSequence.empty)
        left_instructions = @left.compile_vm_instructions(InstructionSequence.empty)
        left_instructions_with_jump = left_instructions +
          InstructionSequence.jump(right_instructions.size + 1)

        split = InstructionSequence.split(1, left_instructions_with_jump.size + 1)

        split + left_instructions_with_jump + right_instructions + following_instructions
      end

      def to_s
        "#{@left}|#{@right}"
      end
    end

    class And < Binary
      def compile_nfa(next_state = AcceptState.new)
        @left.compile_nfa(@right.compile_nfa(next_state))
      end

      def compile_vm_instructions(following_instructions = InstructionSequence.match)
        @left.compile_vm_instructions(InstructionSequence.empty) + @right.compile_vm_instructions(following_instructions)
      end

      def to_s
        "#{@left}#{@right}"
      end
    end

    class Any < Unary
      def compile_nfa(next_state = AcceptState.new)
        res = SplitState.new(nil, next_state)
        res.loop_left(@child.compile_nfa(res))

        res
      end

      def compile_vm_instructions(following_instructions = InstructionSequence.match)
        instructions = @child.compile_vm_instructions(InstructionSequence.empty)
        instructions_with_jump = instructions + InstructionSequence.jump(-instructions.size - 1)

        split = InstructionSequence.split(1, instructions_with_jump.size + 1)

        split + instructions_with_jump + following_instructions
      end

      def to_s
        "#{@child}*"
      end
    end

    class Maybe < Unary
      def compile_nfa(next_state = AcceptState.new)
        SplitState.new(@child.compile_nfa(next_state), next_state)
      end

      def compile_vm_instructions(following_instructions = InstructionSequence.match)
        instructions = @child.compile_vm_instructions(InstructionSequence.empty)

        split = InstructionSequence.split(1, instructions.size + 1)

        split + instructions + following_instructions
      end

      def to_s
        "#{@child}?"
      end
    end

    class AtLeastOne < Unary
      def compile_nfa(next_state = AcceptState.new)
        split = SplitState.new(nil, next_state)
        res = @child.compile_nfa(split)
        split.loop_left(res)

        res
      end

      def compile_vm_instructions(following_instructions = InstructionSequence.match)
        instructions = @child.compile_vm_instructions(InstructionSequence.empty)
        instructions_with_split = instructions + InstructionSequence.split(-instructions.size, 1)

        instructions_with_split + following_instructions
      end

      def to_s
        "#{@child}+"
      end
    end

    class Group < Unary
      def compile_nfa(next_state = AcceptState.new)
        @child.compile_nfa(next_state)
      end

      def compile_vm_instructions(following_instructions = InstructionSequence.match)
        @child.compile_vm_instructions(following_instructions)
      end

      def to_s
        "(#{@child})"
      end
    end
  end
end
