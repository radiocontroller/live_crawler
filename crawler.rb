require 'mechanize'
require 'singleton'
require 'redis'
require 'json'
require './app'

class Crawler
    include Singleton

    def initialize
        @redis = Redis.new
        @logger = Logger.new("*.log")
        @agent = Mechanize.new
        @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def crawl_lol
        begin
            list = []

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/LOL"
            list << douyu_data(page_url)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/lol"
            list << xiongmao_data(page_url)

            # 虎牙直播
            page_url = "http://www.huya.com/g/lol"
            list << huya_data(page_url)

            # 战旗直播
            page_url = "http://www.huya.com/g/lol"
            list << zhanqi_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_LOL_KEY)
        rescue Exception => e
            exception_log(e, "英雄联盟")
        end
    end

    def crawl_lushi
        begin
            list = []

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/How"
            list << douyu_data(page_url)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/hearthstone"
            list << xiongmao_data(page_url)

            # 虎牙直播
            page_url = "http://www.huya.com/g/393"
            list << huya_data(page_url)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/chns/blizzard/how#spm=slider.left"
            list << zhanqi_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_LUSHI_KEY)
        rescue Exception => e
            exception_log(e, "炉石传说")
        end
    end

    def crawl_cf
        begin
            list = []

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/CF"
            list << douyu_data(page_url)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/cf"
            list << xiongmao_data(page_url)

            # 虎牙直播
            page_url = "http://www.huya.com/g/4"
            list << huya_data(page_url)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/games/fps#spm=slider.left"
            list << zhanqi_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_CF_KEY)
        rescue Exception => e
            exception_log(e, "穿越火线")
        end
    end

    def crawl_shouwang
        begin
            list = []

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/Overwatch"
            list << douyu_data(page_url)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/overwatch"
            list << xiongmao_data(page_url)

            # 虎牙直播
            page_url = "http://www.huya.com/g/2174"
            list << huya_data(page_url)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/chns/blizzard/watch#spm=slider.left"
            list << zhanqi_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_SHOUWANG_KEY)
        rescue Exception => e
            exception_log(e, "守望先锋")
        end
    end

    def crawl_wangzhe
        begin
            list = []

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/wzry"
            list << douyu_data(page_url)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/kingglory"
            list << xiongmao_data(page_url)

            # 虎牙直播
            page_url = "http://www.huya.com/g/2336"
            list << huya_data(page_url)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/games/wangzherongyao"
            list << zhanqi_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_WANGZHE_KEY)
        rescue Exception => e
            exception_log(e, "王者荣耀")
        end
    end

    def crawl_dota2
        begin
            list = []

            # 斗鱼直播
            page_url = "https://www.douyu.com/directory/game/DOTA2"
            list << douyu_data(page_url)

            # 熊猫直播
            page_url = "http://www.panda.tv/cate/dota2"
            list << xiongmao_data(page_url)

            # 虎牙直播
            page_url = "http://www.huya.com/g/7"
            list << huya_data(page_url)

            # 战旗直播
            page_url = "https://www.zhanqi.tv/games/dota2#spm=slider.left"
            list << zhanqi_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_DOTA2_KEY)
        rescue Exception => e
            exception_log(e, "DOTA2")
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

        def douyu_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("ul#live-list-contentbox li")
            lives.map do |live|
                {
                    "detail" => {
                        url: "https://www.douyu.com" + live.search("a").attr("href").text,
                        img_url: live.search("img").attr("data-original").text,
                        name: live.search("span.dy-name").text,
                        platform: "斗鱼"
                    },
                    "num" => live.search("span.dy-num").text
                }
            end
        end

        def xiongmao_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("ul#sortdetail-container li")
            lives.map do |live|
                {
                    "detail" => {
                        url: "http://www.panda.tv" + live.search("a").attr("href").text,
                        img_url: live.search("img").attr("data-original").text,
                        name: live.search("span.video-nickname").text,
                        platform: "熊猫"
                    },
                    "num" => live.search("span.video-number").text
                }
            end
        end

        def huya_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("ul#js-live-list li")
            lives.map do |live|
                {
                    "detail" => {
                        url: live.search("a").attr("href").text,
                        img_url: live.search("img").attr("data-original").text,
                        name: live.search("i.nick").text,
                        platform: "虎牙"
                    },
                    "num" => live.search("i.js-num").text
                }
            end
        end

        def zhanqi_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("ul.js-room-list-ul li")
            lives.map do |live|
                {
                    "detail" => {
                        url: "http://www.zhanqi.tv" + live.search("a").attr("href").text,
                        img_url: live.search("img").first.attributes["src"].value,
                        name: live.search("span.anchor").text,
                        platform: "战旗"
                    },
                    "num" => live.search("span.dv").first.text
                }
            end
        end

        def update_lives(list, cache_key)
            @redis.del cache_key
            list.each do |data|
                @redis.zadd(cache_key, convert_float(data["num"]), JSON.generate(data["detail"]))
            end
        end

        def exception_log(e, game)
            @logger.info("----- #{Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')} 抓取#{game}异常 -----")
            @logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
end
