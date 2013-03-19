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

    def source_selection(values, selected)
      values.collect do |v|
        haml_tag :input, :type => 'checkbox', :checked => (selected.collect {|s| s.id}.include? v.id), :class => 'source_list', :name => "source[#{v.id}]", :id => "source_#{v.id}", :value => v.id
        haml_tag :label, v.name, :for => "source_#{v.id}"
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



end
