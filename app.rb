require 'rubygems'
require 'sinatra/base'
require 'json'
require 'redis'
require './crawler'

class App < Sinatra::Base
    $redis = Redis.new
    $logger = Logger.new("*.log")

    LIVES_KEY = "lives:key" # 缓存key

    configure :production do
        get '/' do
            @lives = $redis.hgetall(LIVES_KEY)
            erb :index, :layout => :'layout'
        end
    end
end
