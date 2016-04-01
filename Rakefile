require 'rake/testtask'
require 'rake/clean'

CLEAN.include('*~','**/*~')
#CLOBBER.include('public/css/*.css')

task :default do
   ENV['RACK_ENV'] = 'test'
   Rake::Task['test'].invoke
end

task :init do
     
end


Rake::TestTask.new(:default) do |t|
   t.libs << "test"
   t.pattern = 'test/*_test.rb'
   t.verbose = true
end
