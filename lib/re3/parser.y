class Re3::Parser

token CHAR

rule
  target
    : or_exps { result = val.first }
    ;

  or_exps
    : or_exps '|' exps { result = Or.new(val.first, val.last) }
    | exps { result = val.first }
    ;

  exps
    : exps exp_with_modifier { result = And.new(val.first, val.last) }
    | exp_with_modifier { result = val.first }
    ;

  exp_with_modifier
    : paren_exp '*' { result = Any.new(val.first) }
    | paren_exp '+' { result = AtLeastOne.new(val.first) }
    | paren_exp '?' { result = Maybe.new(val.first) }
    | paren_exp { result = val.first }
    ;

  paren_exp
    : '(' or_exps ')' { result = Group.new(val[1]) }
    | CHAR { result = Char.new(val.first) }

end

---- header

require 're3/scanner'
require 're3/nodes'

---- inner
  include Nodes

  def parse(s)
    @scanner = Scanner.new(s)
    do_parse
  end

  def next_token
    @scanner.next_token
  end
