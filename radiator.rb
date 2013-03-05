#/usr/bin/env ruby
require 'rubygems'
require 'bundler'
Bundler.require(:default,ENV['RACK_ENV'].to_sym)

class Radiator < Sinatra::Base
  helpers Sinatra::ContentFor
  register Sinatra::StaticAssets


  require './models.rb'

  configure :test do 
    puts 'Test configuration in use'
    DataMapper.setup(:default, "sqlite3::memory:")
    DataMapper.auto_migrate!
  end

  configure :development do 
    puts 'Development configuration in use'
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
    DataMapper.auto_upgrade! 
  end

  set :haml, :format => :html5

  get '/' do
    @client = Client.find_or_create_by_ip(request.env['REMOTE_ADDR'])
    @client.lookup_host(request.env['REMOTE_HOST']) if @client.host.nil?
    @client.save
    haml :index
  end

  get '/source/:id' do
    @client = Client.find_or_create_by_ip(request.env['REMOTE_ADDR'])
    @source = Source.get(params[:id])
    haml :source
  end

end