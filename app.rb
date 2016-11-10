require 'rubygems'
require 'sinatra/base'
require 'json'
require 'redis'
require 'rufus/scheduler'
require './crawler'

class App < Sinatra::Base
    scheduler = Rufus::Scheduler.new
    scheduler.every '15s' do
        Crawler.instance.execute
    end

    $redis = Redis.new
    $logger = Logger.new("*.log")

    LIVES_KEY = "lives:key" # 缓存key

    configure :development do
        get '/' do
            @lives = $redis.hgetall(LIVES_KEY)
            erb :index
        end
    end
end
