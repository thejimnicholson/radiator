#/usr/bin/env ruby
require 'rubygems'
require 'bundler'
Bundler.require(:default,(ENV['RACK_ENV']||'development').to_sym)

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
    register Sinatra::Reloader
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
    DataMapper.auto_upgrade!
  end

  configure do
    set :haml, {:format => :html5, :escape_html => false}
    set :scss, {:style => :compact, :debug_info => false}
    Compass.add_project_configuration(File.join(Dir.pwd, 'compass.rb'))
  end

  helpers do
    def options_helper(values,selected)
      values.collect  do |v|
        haml_tag :option, v.title, :value => v.id, :selected => selected.any? {|x| x.id == v.id}
      end
    end
  end

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss(:"stylesheets/#{params[:name]}" ) 
  end

  get '/' do
    @client = Client.find_or_create_by_ip(request.env['REMOTE_ADDR'])
    @client.lookup_host(request.env['REMOTE_HOST']) if @client.host.nil?
    @client.save
    haml :index
  end

  get '/edit/:ip' do
    @client = Client.get(params[:ip])
    @views = View.all
    haml :edit
  end

  post '/edit/:ip' do
    haml :saved
  end


  get '/source/:id' do
    @client = Client.find_or_create_by_ip(request.env['REMOTE_ADDR'])
    @source = Source.get(params[:id])
    haml :source
  end

end