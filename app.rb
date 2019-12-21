# frozen_string_literal: true

require 'rubygems'
require 'sinatra/base'
require 'redis'
require 'json'
require 'will_paginate'
require 'will_paginate/array'
require 'mechanize'

class App < Sinatra::Base
  include WillPaginate::Sinatra::Helpers

  Redis.current = Redis.new(host: 'crawler-redis')

  PLATFORMS = {
    douyu: '斗鱼',
    huya: '虎牙',
    chushou: '触手',
    qie: '企鹅'
  }.freeze

  DOMAINS = {
    douyu: 'https://www.douyu.com',
    huya: 'https://www.huya.com',
    chushou: 'https://chushou.tv',
    qie: 'https://egame.qq.com'
  }.freeze

  KINDS = %w[
    lol lushi cf shouwang wangzhe speed csgo zjgame
    outdoor chess movie show jdqs ninja
  ].each_with_object({}) { |kind, result| result[kind] = "live:#{kind}" }

  PAGE_SIZE = 40

  configure :production do
    enable :logging

    get '/500w' do
      draw = proc do
        arr = (1..33).to_a.shuffle
        r1 = 6.times.map { |idx| '%02d' % arr[idx] }

        arr = (1..16).to_a.shuffle
        r2 = Array('%02d' % arr[0])

        (r1 + r2)
      end
      @numbers = []
      num = (params[:num] || 5).to_i
      num = 5 if num > 100
      num.times.each { |_| @numbers << draw.call }
      erb :draw, layout: false
    end

    KINDS.each do |kind, cache_key|
      get "/#{kind}" do
        @lives = Redis.current.zrevrange(cache_key, 0, -1, with_scores: true)
                       .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
        erb :index, layout: :'layout'
      end

      next if kind != 'lol'

      get '/' do
        @lives = Redis.current.zrevrange(cache_key, 0, -1, with_scores: true)
                       .paginate(page: params[:page] || 1, per_page: PAGE_SIZE)
        erb :index, layout: :'layout'
      end
    end

    helpers do
      def convert_num(num)
        suffix = ''
        if num >= 10_000
          num = (num / 10_000).round(2)
          suffix = '万'
        else
          num = num.to_i
        end
        "#{num}#{suffix}"
      end

      def get_favicon_by(platform_chinese)
        platform = PLATFORMS.invert[platform_chinese]
        File.join(DOMAINS[platform.to_sym], 'favicon.ico')
      end

      def get_class_by(platform_chinese)
        platform = PLATFORMS.invert[platform_chinese]
        platform == 'qie' ? "#{platform}_" : platform
      end
    end
  end
end
