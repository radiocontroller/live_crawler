require 'mechanize'
require 'singleton'
require 'redis'
require 'json'
require './app'

class Crawler
    include Singleton

    def execute
        begin
            logger = Logger.new("*.log")
            redis = Redis.new

            logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl")
            now_f = Time.now.to_f
            agent = Mechanize.new
            agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
            page = agent.get("https://www.douyu.com/directory/all")
            lives = page.search("ul#live-list-contentbox li")
            lives.each_with_index do |live, idx|
                url = "https://www.douyu.com" + live.search("a").attr("href").text
                img_url = live.search("img").attr("data-original").text
                name = live.search("span.dy-name").text
                num = live.search("span.dy-num").text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    num: num
                }
                redis.hset(App::LIVES_KEY, idx, JSON.generate(data))
            end
        rescue Exception => e
            logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end
end
