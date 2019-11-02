require 'rubygems'
require 'sinatra/base'
require 'redis'
require 'json'
require 'will_paginate'
require 'will_paginate/array'
require 'mechanize'

class App < Sinatra::Base
    include WillPaginate::Sinatra::Helpers

    LIVE_LOL_KEY = "live:lol:key"
    LIVE_LUSHI_KEY = "live:lushi:key"
    LIVE_CF_KEY = "live:cf:key"
    LIVE_SHOUWANG_KEY = "live:shouwang:key"
    LIVE_WANGZHE_KEY = "live:wangzhe:key"
    LIVE_SPEED_KEY = "live:speed:key"
    LIVE_CSGO_KEY = "live:csgo:key"
    LIVE_ZJGAME_KEY = "live:zjgame:key"
    LIVE_OUTDOOR_KEY = "live:outdoor:key"
    LIVE_CHESS_KEY = "live:chess:key"
    LIVE_MOVIE_KEY = "live:movie:key"
    LIVE_SHOW_KEY = "live:show:key"
    LIVE_JDQS_KEY = "live:jdqs:key"
    LIVE_NINJA_KEY = "live:ninja:key"

    PAGE_SIZE = 40
    $redis = Redis.new

    configure :production do
        get '/500w' do
          proc = Proc.new do
            arr = (1..33).to_a.shuffle
            r1 = 6.times.map { |_| "%02d" % arr.delete(arr.sample) }

            arr = (1..16).to_a.shuffle
            r2 = Array("%02d" % arr.delete(arr.sample))

            (r1 + r2)
          end
          @numbers = []
          random = proc.call

          while @numbers.size < 5 do
            is_similar = false
            @numbers.each do |number|
              if (number & random).size >= 4
                is_similar = true
                break
              end
            end

            if is_similar
              random = proc.call
            else
              @numbers << random
            end
          end
          erb :draw, :layout => false
        end

        get '/' do
            @lives = $redis.zrevrange(LIVE_LOL_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/zjgame' do
            @lives = $redis.zrevrange(LIVE_ZJGAME_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/jdqs' do
            @lives = $redis.zrevrange(LIVE_JDQS_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/cf' do
            @lives = $redis.zrevrange(LIVE_CF_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/show' do
            @lives = $redis.zrevrange(LIVE_SHOW_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/outdoor' do
            @lives = $redis.zrevrange(LIVE_OUTDOOR_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/hearthstone' do
            @lives = $redis.zrevrange(LIVE_LUSHI_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/overwatch' do
            @lives = $redis.zrevrange(LIVE_SHOUWANG_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/kingglory' do
            @lives = $redis.zrevrange(LIVE_WANGZHE_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/speed' do
            @lives = $redis.zrevrange(LIVE_SPEED_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/csgo' do
            @lives = $redis.zrevrange(LIVE_CSGO_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/chess' do
            @lives = $redis.zrevrange(LIVE_CHESS_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/ninja' do
            @lives = $redis.zrevrange(LIVE_NINJA_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        get '/movie' do
            @lives = $redis.zrevrange(LIVE_MOVIE_KEY, 0, -1, :with_scores => true)
                        .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
            erb :index, :layout => :'layout'
        end

        # get '/huangye' do
        #   erb :huangye, :layout => false
        # end

        helpers do
            def convert_num(num)
                suffix = ""
                if num >= 10_000
                    num = (num / 10_000).round(2)
                    suffix = "万"
                else
                    num = num.to_i
                end
                "#{num}#{suffix}"
            end

            def get_favicon_by(platform)
              case platform
              when "斗鱼"
                "http://www.douyu.com/favicon.ico"
              when "虎牙"
                "http://www.huya.com/favicon.ico"
              when "触手"
                "https://chushou.tv/favicon.ico"
              when "企鹅"
                "https://egame.qq.com/favicon.ico"
              end
            end

            def get_class_by(platform)
              case platform
              when "斗鱼"
                "douyu"
              when "虎牙"
                "huya"
              when "触手"
                "chushou"
              when "企鹅"
                "qie_"
              end
            end
        end
    end
end
