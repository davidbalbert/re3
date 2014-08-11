$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 're3'

require 'benchmark'


1.upto(30) do |n|
  regexp_string = "a?" * n + "a" * n
  input = "a" * n

  puts
  puts "n = #{n}"

  Benchmark.bm do |x|
    x.report("Ruby:") { Regexp.new(regexp_string).match input }
    x.report("Re3: ") { Re3::Regexp.new(regexp_string).match input }
  end
end
