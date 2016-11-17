require 'rubygems'
require 'sinatra/base'

class App < Sinatra::Base
    LIVES_KEY = "lives:key" # 缓存key

    configure :production do
        get '/' do
            @lives = $redis.hgetall(LIVES_KEY)
            erb :index, :layout => :'layout'
        end
    end
end
