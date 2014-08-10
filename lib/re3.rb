require "re3/version"
require 're3/parser'

module Re3
  class Regexp
    def initialize(str)
      @states = Compiler.new(str).compile

    end

    def match(s, engine = :nfa)
    end
  end
end
