#/usr/bin/env ruby
require 'rubygems'
require 'bundler'
Bundler.require(:default,(ENV['RACK_ENV']||'development').to_sym)

# Base controllers for the radiator web UI
class Radiator < Sinatra::Base

  helpers Sinatra::ContentFor
  register Sinatra::StaticAssets

  require './models.rb'

  configure :test do 
    puts 'Test configuration in use'
    DataMapper.setup(:default, "sqlite3::memory:")
    DataMapper.auto_migrate!
    enable :logging
  end

  configure :development do 
    puts 'Development configuration in use'
    register Sinatra::Reloader
    enable :logging
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
    DataMapper.auto_upgrade!
  end

  configure do
    set :haml, {:format => :html5, :escape_html => false}
    set :scss, {:style => :compact, :debug_info => false}
    Compass.add_project_configuration(File.join(Dir.pwd, 'compass.rb'))
  end

  helpers do

    def checkbox_helper(id,css,value,text)
      haml_tag :input, 
         :type => 'checkbox', 
         :checked => value, 
         :class => css, 
         :name => %Q(#{css}[]), 
         :id => id, 
         :value => id
      haml_tag :label, text, :for => id
    end
# todo: Refactor helpers 
    def source_selection(values, selected)
      values.collect do |value|
        haml_tag :input, 
           :type => 'checkbox', 
           :checked => (selected.collect {|source| source.id}.include? value.id), 
           :class => 'source_list', 
           :name => "source[]", 
           :id => "source_#{value.id}", 
           :value => value.id
        haml_tag :label, value.name, :for => "source_#{value.id}"
      end
    end

    def status_image(color)
      if color =~ /anime/
        image_tag %Q(images/#{color}.gif)
      else
        image_tag %Q(images/#{color}.png)
      end
    end
  end

  get '/' do
    @client = Client.find_or_create_by_ip(request.env['REMOTE_ADDR'])
    @client.lookup_host(request.env['REMOTE_HOST']) if @client.host.nil?
    @client.save
    haml :index
  end

  get '/views' do
    @client = Client.get(request.env['REMOTE_ADDR'])
    haml :views, :layout => false
  end

  get '/configure' do
    @client = Client.get(request.env['REMOTE_ADDR'])
    @sources = Source.all
    haml :configure, :layout => false
  end

  post '/configure' do
    @client = Client.get(request.env['REMOTE_ADDR'])
    @client.view.sources = []
    params['source'].each do |sid|
      @client.view.sources << Source.get(sid)
    end
    @client.view.reset_filters
    params['filter'].each do |filter|
      @client.view.send(%Q(#{filter}=).to_sym,true)
    end
    @client.view.save!
    redirect '/',303
  end

  get '/admin' do
    @clients = Client.all
    @sources = Source.all
    haml :admin
  end

end
