require 'rubygems'
require 'bundler'

Bundler.require(:default,ENV['RACK_ENV'].to_sym)

require "sinatra/link_header"
require 'sinatra/static_assets'

require './radiator.rb'
run Radiator