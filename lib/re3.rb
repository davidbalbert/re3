require 're3/version'
require 're3/camelize_string'
require 're3/parser'
require 're3/engines'
require 're3/dot_renderer'

module Re3
  class MatchError < StandardError; end

  class Regexp
    using CamelizeString

    attr_reader :nodes

    def initialize(str)
      @nodes = Parser.new.parse(str)
    end

    def match(s, engine = Engines::ThompsonEngine)
      if engine.is_a? Symbol
        engine = Engines.const_get("#{engine.to_s.camelize}Engine")
      end

      engine.new(@nodes, s).match
    end

    def match!(s, engine = Engines::ThompsonEngine)
      match(s, engine) or raise MatchError, "#{to_s} match failed on input \"#{s}\" with engine \"#{engine}\""
    end

    def to_s
      "#<#{self.class.name} /^#{@nodes.to_s}$/>"
    end
    alias inspect to_s

    def to_dot
      nodes.compile_nfa.to_dot
    end
  end
end
