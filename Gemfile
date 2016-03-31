source "https://rubygems.org"

gem 'compass'
gem 'sinatra', :require => 'sinatra/base', :platform => [:ruby_18, :ruby_19]
gem 'sinatra', :require => 'sinatra/base', git: 'https://github.com/juanpastas/sinatra.git', :platform => :ruby_20
gem 'sinatra-contrib', :require => ['sinatra/json', 'sinatra/content_for','sinatra/reloader'], :platform => [:ruby_18, :ruby_19]
gem 'sinatra-contrib', :require => ['sinatra/json', 'sinatra/content_for','sinatra/reloader'], git: 'https://github.com/sinatra/sinatra-contrib.git', :platform => :ruby_20
gem 'sinatra-static-assets', :require => 'sinatra/static_assets'
gem 'haml'
gem 'json'
#
gem 'dm-sqlite-adapter'
gem 'data_mapper'
#
group :test do 
  gem 'test-unit', :require => 'test/unit'
	gem 'rack-test', :require => 'rack/test'
	gem 'flexmock', :require =>  'flexmock/test_unit'
	gem 'fakeweb', :require => 'fakeweb'
	gem 'nokogiri', :require => 'nokogiri'
end