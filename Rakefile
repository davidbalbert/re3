require "bundler/gem_tasks"

task default: 'lib/re3/parser.rb'

file 'lib/re3/parser.rb' => 'lib/re3/parser.y' do
  sh 'racc -olib/re3/parser.rb lib/re3/parser.y'
end

