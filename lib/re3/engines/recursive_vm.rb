require 're3/vm_instructions'

module Re3
  module Engines
    class RecursiveVmEngine
      include VmInstructions

      def initialize(nodes, input)
        @input = input
        @instructions = nodes.compile_vm_instructions
      end

      def match
        run_vm(0, @input)
      end

      def run_vm(pc, input)
        ins = @instructions[pc]
        case ins
        when Char
          if input[0] != ins.c
            false
          else
            run_vm(pc + 1, input[1..-1])
          end
        when Match
          input.empty?
        when Jump
          run_vm(ins.loc, input)
        when Split
          run_vm(ins.loc1, input) || run_vm(ins.loc2, input)
        end
      end
    end
  end
end
