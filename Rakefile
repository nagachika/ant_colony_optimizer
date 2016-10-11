require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  if ENV["TESTS"].nil? or ENV["TESTS"].empty?
    t.test_files = FileList["test/**/*_test.rb"]
  else
    t.test_files = FileList[ENV["TESTS"]]
  end
end

task :default => :spec
