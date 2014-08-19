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
        loop do
          ins = @instructions[pc]
          case ins
          when Char
            if input[0] != ins.c
              return false
            else
              pc += 1
              input = input[1..-1]
            end
          when Match
            return input.empty?
          when Jump
            pc = ins.loc
          when Split
            return true if run_vm(ins.loc1, input)
            pc = ins.loc2
          end
        end
      end
    end
  end
end
