require 'bundler/gem_tasks'
require 'rake/testtask'

task default: :compile

desc 'Build the regexp parser'
task compile: 'lib/re3/parser.rb'

rule '.rb' => '.y' do |t|
  sh "racc -o #{t.name} #{t.source}"
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
end
