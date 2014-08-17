$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 're3'

require 'benchmark'


1.upto(20) do |n|
  regexp_string = "a?" * n + "a" * n
  input = "a" * n

  puts
  puts "n = #{n}"

  Benchmark.bm do |x|
    x.report("ThompsonEngine: ") { Re3::Regexp.new(regexp_string).match(input, :thompson) }
    x.report("RecursiveEngine:") { Re3::Regexp.new(regexp_string).match(input, :recursive) }
  end
end
