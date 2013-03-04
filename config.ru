require 'rubygems'
require 'bundler'

Bundler.require(:default,ENV['RACK_ENV'].to_sym)

require './radiator.rb'
run Radiator