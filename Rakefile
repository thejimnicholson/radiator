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


namespace :docker do
  namespace :images do
    task :build do
      sh 'docker build -t radiator .'
    end
    task :clean do
      sh 'docker rmi radiator'
    end
  end
 

  task :clean do
    sh 'docker rm radiator'
  end

  task :shell do
    sh 'docker run -it --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.3.1 /bin/bash'
  end

  task :launch do
    sh 'docker run --name radiator --dns=10.1.0.1 -p 3000:3000 -it radiator'
  end

  
end
