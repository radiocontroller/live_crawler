require 'rubygems'
require 'sinatra/base'
require 'redis'
require 'json'

class App < Sinatra::Base
    LIVES_KEY = "lives:key" # 缓存key
    $redis = Redis.new

    configure :production do
        get '/' do
            @lives = $redis.hgetall(LIVES_KEY)
            erb :index, :layout => :'layout'
        end
    end
end
