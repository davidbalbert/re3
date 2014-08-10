class Re3::Parser

token CHAR

rule
  target
    : or_exps { val.first }
    ;

  or_exps
    : or_exps '|' exps { result = [:or, val.first, val.last ] }
    | exps { result = val.first }
    ;

  exps
    : exps exp_with_modifier { result = [:and, val.first, val.last] }
    | exp_with_modifier { result = val.first }
    ;

  exp_with_modifier
    : paren_exp '*' { result = [:any, val.first] }
    | paren_exp '+' { result = [:one_plus, val.first] }
    | paren_exp '?' { result = [:maybe, val.first] }
    | paren_exp { result = val.first }
    ;

  paren_exp
    : '(' or_exps ')' { result = val[1] }
    | CHAR { result = val.first }

end

---- header

require 're3/scanner'

---- inner

  def parse(s)
    @scanner = Scanner.new(s)
    do_parse
  end

  def next_token
    @scanner.next_token
  end
