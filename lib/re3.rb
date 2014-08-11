require "re3/version"
require 're3/parser'
require 're3/nfa'

module Re3
  class Regexp
    def initialize(str)
      @nodes = Parser.new.parse(str)
      @states = Compiler.new(@nodes).compile
    end

    def match(s, engine = :nfa)
    end
  end

  class Compiler
    include NFA

    def initialize(nodes)
      @nodes = nodes
    end

    def compile
      walk_and_compile(@nodes, AcceptState.new)
    end

    private
    def walk_and_compile(nodes, next_state)
      case nodes[0]
      when :char
        State.new(nodes[1], next_state)
      when :and
        right = walk_and_compile(nodes[2], next_state)
        walk_and_compile(nodes[1], right)
      when :or
        left = walk_and_compile(nodes[1], next_state)
        right = walk_and_compile(nodes[2], next_state)
        SplitState.new(left, right)
      when :maybe
        SplitState.new(walk_and_compile(nodes[1], next_state), next_state)
      when :any
        res = SplitState.new(nil, next_state)
        res.loop_left(walk_and_compile(nodes[1], res))

        res
      when :one_plus
        split = SplitState.new(nil, next_state)
        res = walk_and_compile(nodes[1], split)
        split.loop_left(res)

        res
      end
    end

  end
end
