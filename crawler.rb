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
            list = []
            game = "英雄联盟"

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/LOL"
            list << douyu_data(page_url, game)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/lol"
            list << xiongmao_data(page_url, game)

            # 虎牙直播
            page_url = "http://www.huya.com/g/lol"
            list << huya_data(page_url, game)

            # 战旗直播
            page_url = "http://www.huya.com/g/lol"
            list << zhanqi_data(page_url, game)

            list.flatten!

            # 更新数据
            @@redis.del(App::LIVE_LOL_KEY)
            list.each do |data|
                @@redis.zadd(App::LIVE_LOL_KEY, convert_float(data["num"]), JSON.generate(data["detail"]))
            end
        rescue Exception => e
            @@logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end

    def crawl_lushi
        begin
            list = []
            game = "炉石传说"

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/How"
            list << douyu_data(page_url, game)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/hearthstone"
            list << xiongmao_data(page_url, game)

            # 虎牙直播
            page_url = "http://www.huya.com/g/393"
            list << huya_data(page_url, game)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/chns/blizzard/how#spm=slider.left"
            list << zhanqi_data(page_url, game)

            list.flatten!

            # 更新数据
            @@redis.del(App::LIVE_LUSHI_KEY)
            list.each do |data|
                @@redis.zadd(App::LIVE_LUSHI_KEY, convert_float(data["num"]), JSON.generate(data["detail"]))
            end
        rescue Exception => e
            @@logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end

    def crawl_cf
        begin
            list = []
            game = "穿越火线"

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/CF"
            list << douyu_data(page_url, game)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/cf"
            list << xiongmao_data(page_url, game)

            # 虎牙直播
            page_url = "http://www.huya.com/g/4"
            list << huya_data(page_url, game)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/games/fps#spm=slider.left"
            list << zhanqi_data(page_url, game)

            list.flatten!

            # 更新数据
            @@redis.del(App::LIVE_CF_KEY)
            list.each do |data|
                @@redis.zadd(App::LIVE_CF_KEY, convert_float(data["num"]), JSON.generate(data["detail"]))
            end
        rescue Exception => e
            @@logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end

    def crawl_shouwang
        begin
            list = []
            game = "守望先锋"

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/Overwatch"
            list << douyu_data(page_url, game)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/overwatch"
            list << xiongmao_data(page_url, game)

            # 虎牙直播
            page_url = "http://www.huya.com/g/2174"
            list << huya_data(page_url, game)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/chns/blizzard/watch#spm=slider.left"
            list << zhanqi_data(page_url, game)

            list.flatten!

            # 更新数据
            @@redis.del(App::LIVE_SHOUWANG_KEY)
            list.each do |data|
                @@redis.zadd(App::LIVE_SHOUWANG_KEY, convert_float(data["num"]), JSON.generate(data["detail"]))
            end
        rescue Exception => e
            @@logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end

    def crawl_wangzhe
        begin
            list = []
            game = "王者荣耀"

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/wzry"
            list << douyu_data(page_url, game)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/kingglory"
            list << xiongmao_data(page_url, game)

            # 虎牙直播
            page_url = "http://www.huya.com/g/2336"
            list << huya_data(page_url, game)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/games/wangzherongyao"
            list << zhanqi_data(page_url, game)

            list.flatten!

            # 更新数据
            @@redis.del(App::LIVE_WANGZHE_KEY)
            list.each do |data|
                @@redis.zadd(App::LIVE_WANGZHE_KEY, convert_float(data["num"]), JSON.generate(data["detail"]))
            end
        rescue Exception => e
            @@logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
    end

    def crawl_dota2
        begin
            list = []
            game = "DOTA2"

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/DOTA2"
            list << douyu_data(page_url, game)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/dota2"
            list << xiongmao_data(page_url, game)

            # 虎牙直播
            page_url = "http://www.huya.com/g/7"
            list << huya_data(page_url, game)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/games/dota2#spm=slider.left"
            list << zhanqi_data(page_url, game)

            list.flatten!

            # 更新数据
            @@redis.del(App::LIVE_DOTA2_KEY)
            list.each do |data|
                @@redis.zadd(App::LIVE_DOTA2_KEY, convert_float(data["num"]), JSON.generate(data["detail"]))
            end
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

        def douyu_data(page_url, game)
            platform = "斗鱼"
            start_log(platform, game)
            page = @@agent.get(page_url)
            finish_log(platform, game)
            lives = page.search("ul#live-list-contentbox li")
            lives.map do |live|
                {
                    "detail" => {
                        url: "https://www.douyu.com" + live.search("a").attr("href").text,
                        img_url: live.search("img").attr("data-original").text,
                        name: live.search("span.dy-name").text,
                        platform: platform
                    },
                    "num" => live.search("span.dy-num").text
                }
            end
        end

        def xiongmao_data(page_url, game)
            platform = "熊猫"
            start_log(platform, game)
            page = @@agent.get(page_url)
            finish_log(platform, game)
            lives = page.search("ul#sortdetail-container li")
            lives.map do |live|
                {
                    "detail" => {
                        url: "http://www.panda.tv" + live.search("a").attr("href").text,
                        img_url: live.search("img").attr("data-original").text,
                        name: live.search("span.video-nickname").text,
                        platform: platform
                    },
                    "num" => live.search("span.video-number").text
                }
            end
        end

        def huya_data(page_url, game)
            platform = "虎牙"
            start_log(platform, game)
            page = @@agent.get(page_url)
            finish_log(platform, game)
            lives = page.search("ul#js-live-list li")
            lives.map do |live|
                {
                    "detail" => {
                        url: live.search("a").attr("href").text,
                        img_url: live.search("img").attr("data-original").text,
                        name: live.search("i.nick").text,
                        platform: platform
                    },
                    "num" => live.search("i.js-num").text
                }
            end
        end

        def zhanqi_data(page_url, game)
            platform = "战旗"
            start_log(platform, game)
            page = @@agent.get(page_url)
            finish_log(platform, game)
            lives = page.search("ul.js-room-list-ul li")
            lives.map do |live|
                {
                    "detail" => {
                        url: "http://www.zhanqi.tv" + live.search("a").attr("href").text,
                        img_url: live.search("img").first.attributes["src"].value,
                        name: live.search("span.anchor").text,
                        platform: platform
                    },
                    "num" => live.search("span.dv").first.text
                }
            end
        end

        def start_log(platform, game)
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')} 开始抓取#{platform} #{game}直播")
        end

        def finish_log(platform, game)
            @@logger.info("#{Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')} 结束抓取#{platform} #{game}直播")
        end
end
