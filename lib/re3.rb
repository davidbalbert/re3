require "re3/version"
require 're3/parser'

module Re3
  class Regexp
    def initialize(str)
      @states = Parser.compile(str)
    end

    def match(s, engine = :nfa)
    end
  end
end
