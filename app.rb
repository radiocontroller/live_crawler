require 'rubygems'
require 'sinatra/base'
require 'json'
require 'mechanize'
require 'redis'

class App < Sinatra::Base
    $redis = Redis.new
    $logger = Logger.new("*.log")
    # environment = ENV["RACK_ENV"] || 'development'
    # Mongoid.load!(File.expand_path(File.join("config", "mongoid.yml")), environment)

    configure :development do
        before do
            begin
                now_f = Time.now.to_f
                agent = Mechanize.new
                agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
                # agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                # agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
                page = agent.get("https://www.douyu.com/directory/all")
                lives = page.search("ul#live-list-contentbox li")
                lives.each do |live|
                    live_url = "https://www.douyu.com" + live.search("a").attr("href").text
                    img_url = live.search("img").attr("data-original").text
                    name = live.search("span.dy-name").text
                    num = live.search("span.dy-num").text
                    data = {
                        live_url: live_url,
                        img_url: img_url,
                        name: name,
                        num: num
                    }
                    $redis.zadd("lives:key", now_f, JSON.generate(data))
                end
            rescue Exception => e
                $logger.info("get page error")
            end
        end

        get '/' do
            end_at = Time.now.to_f
            start_at = end_at - params[:ts].to_i
            @lives = $redis.zrevrangebyscore("lives:key", end_at, start_at)
            erb :index
        end
    end
end
