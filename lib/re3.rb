require "re3/version"
require 're3/parser'

module Re3
  class Regexp
    attr_reader :states

    def initialize(str)
      @nodes = Parser.new.parse(str)
      @states = @nodes.compile
    end

    def match(s, engine = :nfa)
    end

    def to_s
      "#<#{self.class.name} /^#{@nodes.to_s}$/>"
    end
    alias inspect to_s
  end
end
