require 'rubygems'
require 'sinatra/base'
require 'json'
require 'mongoid'
require './models/user'

class App < Sinatra::Base
    environment = ENV["RACK_ENV"] || 'development'
    Mongoid.load!(File.expand_path(File.join("config", "mongoid.yml")), environment)

    configure :development do
        get '/' do
            @name = "james"
            erb :index
        end
    end
end
