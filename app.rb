require 'rubygems'
require 'sinatra/base'
require 'redis'
require 'json'
require 'will_paginate'
require 'will_paginate/array'

class App < Sinatra::Base
    include WillPaginate::Sinatra::Helpers

    LIVE_LOL_KEY = "live:lol:key"
    LIVE_LUSHI_KEY = "live:lushi:key"
    $redis = Redis.new

    configure :production do
        get '/' do
            @lives = $redis.zrevrange(LIVE_LOL_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: 80)
            erb :index, :layout => :'layout'
        end

        get '/hearthstone' do
            @lives = $redis.zrevrange(LIVE_LUSHI_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: 80)
            erb :index, :layout => :'layout'
        end

        helpers do
            def convert_num(num)
                suffix = ""
                if num > 10_000
                    num = (num / 10_000).round(2)
                    suffix = "万"
                else
                    num = num.to_i
                end
                "#{num}#{suffix}"
            end
        end
    end
end
