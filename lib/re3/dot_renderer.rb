require 'set'

module Re3
  class DotRenderer
    NamedNode = Struct.new(:name, :state, :accept_state) do
      def to_s
        s = "  #{name}"
        s += " [shape=doublecircle]" if accept_state
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

    def initialize(start_state)
      @start_state = start_state
      @state_counter = 0

      @processed_nodes = Set.new
      @node_map = {}
      @node_queue = []
    end

    def to_dot
      edges = get_edges

      nodes_string = @node_map.values.map(&:to_s).join("\n") + "\n"
      edges_string = edges.map(&:to_s).join("\n") + "\n"

      PREAMBLE + nodes_string + edges_string + POSTAMBLE
    end

    private
    def get_edges
      edges = []
      enqueue(node_for(@start_state))

      until @node_queue.empty?
        n = dequeue

        name = n.name
        state = n.state

        case state
        when States::State
          next_node = node_for(state.next_state)
          enqueue(next_node)

          edges << Edge.new(name, next_node.name, state.char)
        when States::SplitState
          n1 = node_for(state.left)
          n2 = node_for(state.right)

          enqueue(n1)
          enqueue(n2)

          edges << Edge.new(name, n1.name, nil)
          edges << Edge.new(name, n2.name, nil)
        end
      end

      edges
    end

    def enqueue(node)
      @node_queue << node unless @processed_nodes.include? node
    end

    def dequeue
      n = @node_queue.shift
      @processed_nodes << n

      n
    end

    def node_for(state)
      unless @node_map.has_key?(state)
        n = NamedNode.new(next_name, state)
        n.accept_state = true if state.accepts?
        @node_map[state] = n
      end

      @node_map[state]
    end

    def next_name
      name = "s#{@state_counter}"
      @state_counter += 1

      name
    end
  end
end
