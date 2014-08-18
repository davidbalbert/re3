module Re3
  module VmInstructions
    Char = Struct.new(:c) do
      def add_offset(offset)
        self
      end

      def to_s
        "char #{c}"
      end
    end

    Match = Class.new do
      def add_offset(offset)
        self
      end

      def to_s
        "match"
      end
    end

    Jump = Struct.new(:loc) do
      def add_offset(offset)
        self.class.new(loc + offset)
      end

      def to_s
        "jump #{loc}"
      end
    end

    Split = Struct.new(:loc1, :loc2) do
      def add_offset(offset)
        self.class.new(loc1 + offset, loc2 + offset)
      end

      def to_s
        "split #{loc1}, #{loc2}"
      end
    end

    class InstructionSequence
      def self.empty
        new
      end

      def self.jump(loc)
        new(Jump.new(loc))
      end

      def self.split(loc1, loc2)
        new(Split.new(loc1, loc2))
      end

      def self.char(c)
        new(Char.new(c))
      end

      def self.match
        new(Match.new)
      end

      def initialize(*instructions)
        @instructions = instructions
      end

      def size
        @instructions.size
      end

      def [](i)
        @instructions[i]
      end

      def +(other)
        new_instructions = @instructions + other.instructions_with_offset(size)
        self.class.new(*new_instructions)
      end

      def to_s
        @instructions.map.with_index do |ins, i|
          "#{i}\t#{ins}"
        end.join("\n")
      end

      protected
      def instructions_with_offset(offset)
        @instructions.map { |ins| ins.add_offset(offset) }
      end
    end
  end
end
