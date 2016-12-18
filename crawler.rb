require 'mechanize'
require 'singleton'
require 'redis'
require 'json'
require './app'

class Crawler
    include Singleton

    @@redis = Redis.new
    @@logger = Logger.new("*.log")
    @@agent = Mechanize.new
    @@agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

    def crawl_lol
        begin
            @@redis.del(App::LIVE_LOL_KEY)

            # 斗鱼直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl douyu lol lives")
            page = @@agent.get("https://www.douyu.com/directory/game/LOL")
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
                    platform: "斗鱼"
                }
                @@redis.zadd(App::LIVE_LOL_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl douyu lol lives")

            # 熊猫直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl xiongmao lol lives")
            page = @@agent.get("http://www.panda.tv/cate/lol")
            lives = page.search("ul#sortdetail-container li")
            lives.each_with_index do |live, idx|
                url = "http://www.panda.tv" + live.search("a").attr("href").text
                img_url = live.search("img").attr("data-original").text
                name = live.search("span.video-nickname").text
                num = live.search("span.video-number").text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "熊猫"
                }
                @@redis.zadd(App::LIVE_LOL_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl xiongmao lol lives")

            # 虎牙直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl huya lol lives")
            page = @@agent.get("http://www.huya.com/g/lol")
            lives = page.search("ul#js-live-list li")
            lives.each_with_index do |live, idx|
                url = live.search("a").attr("href").text
                img_url = live.search("img").attr("data-original").text
                name = live.search("i.nick").text
                num = live.search("i.js-num").text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "虎牙"
                }
                @@redis.zadd(App::LIVE_LOL_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl huya lol lives")

            # 战旗直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl zhanqi lol lives")
            page = @@agent.get("http://www.zhanqi.tv/games/lol")
            lives = page.search("ul.js-room-list-ul li")
            lives.each_with_index do |live, idx|
                url = "http://www.zhanqi.tv" + live.search("a").attr("href").text
                img_url = live.search("img").first.attributes["src"].value
                name = live.search("span.anchor").text
                num = live.search("span.dv").first.text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "战旗"
                }
                @@redis.zadd(App::LIVE_LOL_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl zhanqi lol lives")

        rescue Exception => e
            @@logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end

    def crawl_lushi
        begin
            @@redis.del(App::LIVE_LUSHI_KEY)

            # 斗鱼直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl douyu lushi lives")
            page = @@agent.get("https://www.douyu.com/directory/game/How")
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
                    platform: "斗鱼"
                }
                @@redis.zadd(App::LIVE_LUSHI_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl douyu lushi lives")

            # 熊猫直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl xiongmao lushi lives")
            page = @@agent.get("http://www.panda.tv/cate/hearthstone")
            lives = page.search("ul#sortdetail-container li")
            lives.each_with_index do |live, idx|
                url = "http://www.panda.tv" + live.search("a").attr("href").text
                img_url = live.search("img").attr("data-original").text
                name = live.search("span.video-nickname").text
                num = live.search("span.video-number").text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "熊猫"
                }
                @@redis.zadd(App::LIVE_LUSHI_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl xiongmao lushi lives")

            # 虎牙直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl huya lushi lives")
            page = @@agent.get("http://www.huya.com/g/393")
            lives = page.search("ul#js-live-list li")
            lives.each_with_index do |live, idx|
                url = live.search("a").attr("href").text
                img_url = live.search("img").attr("data-original").text
                name = live.search("i.nick").text
                num = live.search("i.js-num").text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "虎牙"
                }
                @@redis.zadd(App::LIVE_LUSHI_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl huya lushi lives")

            # 战旗直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl zhanqi lushi lives")
            page = @@agent.get("https://www.zhanqi.tv/chns/blizzard/how#spm=slider.left")
            lives = page.search("ul.js-room-list-ul li")
            lives.each_with_index do |live, idx|
                url = "http://www.zhanqi.tv" + live.search("a").attr("href").text
                img_url = live.search("img").first.attributes["src"].value
                name = live.search("span.anchor").text
                num = live.search("span.dv").first.text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "战旗"
                }
                @@redis.zadd(App::LIVE_LUSHI_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl zhanqi lushi lives")

        rescue Exception => e
            @@logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end

    def crawl_cf
        begin
            @@redis.del(App::LIVE_CF_KEY)

            # 斗鱼直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl douyu cf lives")
            page = @@agent.get("https://www.douyu.com/directory/game/CF")
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
                    platform: "斗鱼"
                }
                @@redis.zadd(App::LIVE_CF_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl douyu cf lives")

            # 熊猫直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl xiongmao cf lives")
            page = @@agent.get("http://www.panda.tv/cate/cf")
            lives = page.search("ul#sortdetail-container li")
            lives.each_with_index do |live, idx|
                url = "http://www.panda.tv" + live.search("a").attr("href").text
                img_url = live.search("img").attr("data-original").text
                name = live.search("span.video-nickname").text
                num = live.search("span.video-number").text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "熊猫"
                }
                @@redis.zadd(App::LIVE_CF_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl xiongmao cf lives")

            # 虎牙直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl huya cf lives")
            page = @@agent.get("http://www.huya.com/g/4")
            lives = page.search("ul#js-live-list li")
            lives.each_with_index do |live, idx|
                url = live.search("a").attr("href").text
                img_url = live.search("img").attr("data-original").text
                name = live.search("i.nick").text
                num = live.search("i.js-num").text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "虎牙"
                }
                @@redis.zadd(App::LIVE_CF_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl huya cf lives")

            # 战旗直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl zhanqi cf lives")
            page = @@agent.get("https://www.zhanqi.tv/games/fps#spm=slider.left")
            lives = page.search("ul.js-room-list-ul li")
            lives.each_with_index do |live, idx|
                url = "http://www.zhanqi.tv" + live.search("a").attr("href").text
                img_url = live.search("img").first.attributes["src"].value
                name = live.search("span.anchor").text
                num = live.search("span.dv").first.text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "战旗"
                }
                @@redis.zadd(App::LIVE_CF_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl zhanqi cf lives")

        rescue Exception => e
            @@logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end

    def crawl_shouwang
        begin
            @@redis.del(App::LIVE_SHOUWANG_KEY)

            # 斗鱼直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl douyu shouwang lives")
            page = @@agent.get("https://www.douyu.com/directory/game/Overwatch")
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
                    platform: "斗鱼"
                }
                @@redis.zadd(App::LIVE_SHOUWANG_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl douyu shouwang lives")

            # 熊猫直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl xiongmao shouwang lives")
            page = @@agent.get("http://www.panda.tv/cate/overwatch")
            lives = page.search("ul#sortdetail-container li")
            lives.each_with_index do |live, idx|
                url = "http://www.panda.tv" + live.search("a").attr("href").text
                img_url = live.search("img").attr("data-original").text
                name = live.search("span.video-nickname").text
                num = live.search("span.video-number").text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "熊猫"
                }
                @@redis.zadd(App::LIVE_SHOUWANG_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl xiongmao shouwang lives")

            # 虎牙直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl huya shouwang lives")
            page = @@agent.get("http://www.huya.com/g/2174")
            lives = page.search("ul#js-live-list li")
            lives.each_with_index do |live, idx|
                url = live.search("a").attr("href").text
                img_url = live.search("img").attr("data-original").text
                name = live.search("i.nick").text
                num = live.search("i.js-num").text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "虎牙"
                }
                @@redis.zadd(App::LIVE_SHOUWANG_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl huya shouwang lives")

            # 战旗直播
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} begin crawl zhanqi shouwang lives")
            page = @@agent.get("https://www.zhanqi.tv/chns/blizzard/watch#spm=slider.left")
            lives = page.search("ul.js-room-list-ul li")
            lives.each_with_index do |live, idx|
                url = "http://www.zhanqi.tv" + live.search("a").attr("href").text
                img_url = live.search("img").first.attributes["src"].value
                name = live.search("span.anchor").text
                num = live.search("span.dv").first.text
                data = {
                    url: url,
                    img_url: img_url,
                    name: name,
                    platform: "战旗"
                }
                @@redis.zadd(App::LIVE_SHOUWANG_KEY, convert_float(num), JSON.generate(data))
            end
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} finish crawl zhanqi shouwang lives")

        rescue Exception => e
            @@logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end

    private

        # 在线人数字符串转浮点型
        def convert_float(num)
            base = 1
            if num.include?("万")
                num.gsub!("万", "")
                base = 10_000
            end
            num.to_f * base
        end
end
