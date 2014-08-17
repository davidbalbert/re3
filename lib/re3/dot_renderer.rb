require 'set'

module Re3
  class DotRenderer
    NamedNode = Struct.new(:name, :state, :accept_state) do
      def to_s
        s = "  #{name}"

        if accept_state
          s += " [shape=doublecircle]"
        else
          s += " [shape=circle]"
        end

        s += ";"
      end
    end

    Edge = Struct.new(:from, :to, :label) do
      def to_s
        s = "  #{from} -> #{to}"
        s += " [label=\"#{label}\"]" if label
        s += ";"

        s
      end
    end

    PREAMBLE = <<EOS
digraph out {
  rankdir=LR
  splines=true;
  sep="+25,25";
  overlap=scalexy;
  nodesep=0.6;
EOS

    POSTAMBLE = "}\n"

    include States

    class NonRepeatingQueue
      def initialize
        @q = []
        @seen = Set.new
      end

      def empty?
        @q.empty?
      end

      def enqueue(o)
        @q << o unless @seen.include? o
      end

      def dequeue
        o = @q.shift
        @seen << o

        o
      end
    end

    def initialize(start_state)
      @start_state = start_state
      @state_counter = 0

      @node_cache = {}
    end

    def to_dot
      nodes = get_nodes
      edges = get_edges(nodes)

      nodes_string = nodes.map(&:to_s).join("\n") + "\n"
      edges_string = edges.map(&:to_s).join("\n") + "\n"

      PREAMBLE + nodes_string + edges_string + POSTAMBLE
    end

    private
    def get_nodes
      nodes = []
      q = NonRepeatingQueue.new
      q.enqueue(node_for(@start_state))

      until q.empty?
        n = q.dequeue

        nodes << n

        name = n.name
        state = n.state

        case state
        when State
          next_node = node_for(state.next_state)
          q.enqueue(next_node)
        when SplitState
          q.enqueue(node_for(state.left))
          q.enqueue(node_for(state.right))
        end
      end

      nodes
    end

    def get_edges(nodes)
      nodes.map do |n|
        state = n.state
        name = n.name

        case state
        when State
          next_state = node_for(state.next_state)
          [Edge.new(name, next_state.name, state.char)]
        when SplitState
          n1 = node_for(state.left)
          n2 = node_for(state.right)

          [Edge.new(name, n1.name, nil), Edge.new(name, n2.name, nil)]
        when AcceptState
          []
        end
      end.reduce(:+)
    end

    def node_for(state)
      unless @node_cache.has_key?(state)
        n = NamedNode.new(next_name, state)
        n.accept_state = true if state.accepts?
        @node_cache[state] = n
      end

      @node_cache[state]
    end

    def next_name
      name = "s#{@state_counter}"
      @state_counter += 1

      name
    end
  end
end
