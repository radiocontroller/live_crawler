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

    before do
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.headers["Access-Control-Allow-Methods"] = "GET"
    end

    configure :production do
        get '/wx' do
          begin
            token = "rcer"
            arr = [token, params["timestamp"], params["nonce"]]
            sign = Digest::SHA1.hexdigest(arr.sort.join)
            if sign == params["signature"]
              params["echostr"]
            else
              'error !'
            end
          rescue ArgumentError
            'argument error !'
          rescue Exception
            'exception !'
          end
        end

        get '/api/headers' do
          return nil if params[:zsh].nil?
          [
            { title: '英雄联盟', path: 'lol' },
            { title: '主机游戏', path: 'zjgame' },
            { title: '绝地求生', path: 'jdqs' },
            { title: '穿越火线', path: 'cf' },
            { title: '娱乐音乐', path: 'show' },
            { title: '户外直播', path: 'outdoor' },
            { title: '炉石传说', path: 'lushi' },
            { title: '守望先锋', path: 'shouwang' },
            { title: '王者荣耀', path: 'wangzhe' },
            { title: 'QQ飞车', path: 'speed' },
            { title: 'CS:GO', path: 'csgo' },
            { title: '棋牌竞技', path: 'chess' },
            { title: '忍3', path: 'ninja' },
            { title: '电影相关', path: 'movie' }
          ].to_json
        end

        get '/api/lives' do
          return nil if params[:zsh].nil?
          key = App.const_get "LIVE_#{params[:key].upcase}_KEY"
          $redis.zrevrange(key, 0, -1, :with_scores => true)
                 .paginate(page: params[:page] || 1, per_page: PAGE_SIZE).to_json
        end

        get '/api/lives/size' do
          return nil if params[:zsh].nil?
          key = App.const_get "LIVE_#{params[:key].upcase}_KEY"
          { page_size: PAGE_SIZE, total_size: $redis.zrevrange(key, 0, -1, :with_scores => true).size }.to_json
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

        get '/huangye' do
          erb :huangye, :layout => false
        end

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
              when "熊猫"
                "https://www.panda.tv/favicon.ico"
              when "龙珠"
                "http://www.longzhu.com/favicon.ico"
              when "全民"
                "https://www.quanmin.tv/favicon.ico"
              when "触手"
                "https://chushou.tv/favicon.ico"
              end
            end

            def get_class_by(platform)
              case platform
              when "斗鱼"
                "douyu"
              when "虎牙"
                "huya"
              when "熊猫"
                "xiongmao"
              when "龙珠"
                "longzhu"
              when "全民"
                "quanmin"
              when "触手"
                "chushou"
              end
            end
        end
    end
end
