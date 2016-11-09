require 'rubygems'
require 'sinatra/base'
require 'json'
require 'mongoid'
require './models/user'

class App < Sinatra::Base
    environment = ENV["RACK_ENV"] || 'development'
    Mongoid.load!(File.expand_path(File.join("config", "mongoid.yml")), environment)

    configure :development do
        helpers do
        end

        before do
        end

        get '/users' do
            User.all.map { |u| { name: u.name } }.to_json
        end
    end
end
