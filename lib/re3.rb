require 're3/version'
require 're3/parser'
require 're3/engines'

require 'set'

module Re3
  class Regexp
    attr_reader :start_state

    def initialize(str)
      @nodes = Parser.new.parse(str)
      @start_state = @nodes.compile
    end

    def match(s, engine = Engines::ThompsonEngine)
      engine.new(self, s).match
    end

    def to_s
      "#<#{self.class.name} /^#{@nodes.to_s}$/>"
    end
    alias inspect to_s
  end
end
