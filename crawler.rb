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
	    @agent.max_history = 0
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

            # 龙珠直播
            page_url = "http://longzhu.com/channels/lol?from=rmgame"
            list << longzhu_data(page_url)

            # 全民tv
            page_url = "http://www.quanmin.tv/game/lol"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_LOL_KEY)
        rescue Exception => e
            exception_log(e, "英雄联盟")
        end
	    @agent.history.clear
	    GC.start
    end

    def crawl_zjgame
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/TVgame"
            list << douyu_data(page_url)

            page_url = "http://www.panda.tv/cate/zhuji"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/ZJGAME"
            list << huya_data(page_url)

            page_url = "http://longzhu.com/channels/djzjjj?from=topbargame"
            list << longzhu_data(page_url)

            page_url = "http://www.quanmin.tv/game/tvgame"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_ZJGAME_KEY)
        rescue Exception => e
            exception_log(e, "主机游戏")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_jdqs
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/jdqs"
            list << douyu_data(page_url)

            page_url = "https://www.panda.tv/cate/pubg"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/2793"
            list << huya_data(page_url)

            page_url = "http://longzhu.com/channels/jdqs?from=figame"
            list << longzhu_data(page_url)

            page_url = "https://www.quanmin.tv/game/juediqiusheng"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_JDQS_KEY)
        rescue Exception => e
            exception_log(e, "绝地求生")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_cf
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/CF"
            list << douyu_data(page_url)

            page_url = "http://www.panda.tv/cate/cf"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/4"
            list << huya_data(page_url)

            page_url = "http://longzhu.com/channels/cf?from=topbargame"
            list << longzhu_data(page_url)

            page_url = "http://www.quanmin.tv/game/cfpc"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_CF_KEY)
        rescue Exception => e
            exception_log(e, "穿越火线")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_outdoor
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/HW"
            list << douyu_data(page_url)

            page_url = "http://www.panda.tv/cate/hwzb"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/2836"
            list << huya_data(page_url)

            page_url = "http://longzhu.com/channels/huwai"
            list << longzhu_data(page_url)

            page_url = "http://www.quanmin.tv/game/huwai"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_OUTDOOR_KEY)
        rescue Exception => e
            exception_log(e, "户外直播")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_lushi
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/How"
            list << douyu_data(page_url)

            page_url = "http://www.panda.tv/cate/hearthstone"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/393"
            list << huya_data(page_url)

            page_url = "http://longzhu.com/channels/hs"
            list << longzhu_data(page_url)

            page_url = "http://www.quanmin.tv/game/hearthstone"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_LUSHI_KEY)
        rescue Exception => e
            exception_log(e, "炉石传说")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_shouwang
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/Overwatch"
            list << douyu_data(page_url)

            page_url = "http://www.panda.tv/cate/overwatch"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/2174"
            list << huya_data(page_url)

            page_url = "http://longzhu.com/channels/ow"
            list << longzhu_data(page_url)

            page_url = "http://www.quanmin.tv/game/overwatch"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_SHOUWANG_KEY)
        rescue Exception => e
            exception_log(e, "守望先锋")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_wangzhe
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/wzry"
            list << douyu_data(page_url)

            page_url = "http://www.panda.tv/cate/kingglory"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/2336"
            list << huya_data(page_url)

            page_url = "http://longzhu.com/channels/wzry"
            list << longzhu_data(page_url)

            page_url = "http://www.quanmin.tv/game/wangzhe"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_WANGZHE_KEY)
        rescue Exception => e
            exception_log(e, "王者荣耀")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_speed
        begin
            list = []

            page_url = "https://www.douyu.com/directory/subCate/jingsu/396"
            list << douyu_data(page_url)

            page_url = "http://www.quanmin.tv/game/qqfeiche"
            list << quanmin_data(page_url)

            page_url = "http://www.huya.com/g/9"
            list << huya_data(page_url)

            page_url = "http://longzhu.com/channels/speed?from=figame"
            list << longzhu_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_SPEED_KEY)
        rescue Exception => e
            exception_log(e, "QQ飞车")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_csgo
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/CSGO"
            list << douyu_data(page_url)

            page_url = "http://www.panda.tv/cate/csgo"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/862"
            list << huya_data(page_url)

            page_url = "http://longzhu.com/channels/csgo"
            list << longzhu_data(page_url)

            page_url = "http://www.quanmin.tv/game/csgo"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_CSGO_KEY)
        rescue Exception => e
            exception_log(e, "csgo")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_chess
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/qipai"
            list << douyu_data(page_url)

            page_url = "http://www.panda.tv/cate/qipai"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/100036"
            list << huya_data(page_url)

            page_url = "http://www.quanmin.tv/game/qipai"
            list << quanmin_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_CHESS_KEY)
        rescue Exception => e
            exception_log(e, "棋牌竞技")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_movie
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/stdp"
            list << douyu_data(page_url)

            page_url = "http://www.panda.tv/cate/cartoon"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/seeTogether"
            list << huya_data(page_url)

            page_url = "http://www.quanmin.tv/game/dzh"
            list << quanmin_data(page_url)

            page_url = "http://longzhu.com/channels/movie"
            list << longzhu_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_MOVIE_KEY)
        rescue Exception => e
            exception_log(e, "电影相关")
        end
    	@agent.history.clear
    	GC.start
    end

    def crawl_show
        begin
            list = []

            page_url = "https://www.douyu.com/directory/game/xingyu"
            list << douyu_data(page_url)

            page_url = "https://www.panda.tv/cate/yzdr"
            list << xiongmao_data(page_url)

            page_url = "http://www.huya.com/g/xingxiu"
            list << huya_data(page_url)

            # page_url = "https://www.quanmin.tv/game/showing"
            # list << quanmin_data(page_url)

            # page_url = "http://longzhu.com/channels/lzxx"
            # list << longzhu_data(page_url)

            list.flatten!

            update_lives(list, App::LIVE_SHOW_KEY)
        rescue Exception => e
            exception_log(e, "星娱星秀")
        end
        @agent.history.clear
        GC.start
    end

    private

        # 在线人数字符串转浮点型
        def convert_float(num)
            base = 1
            if num.include?("万人")
                num.gsub!("万人", "")
                base = 10_000
            elsif num.include?("万")
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
                        title: live.search("h3.ellipsis").text.strip,
                        platform: "斗鱼"
                    },
                    "num" => live.search("span.dy-num").text
                }
            end
        end

        def xiongmao_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("ul#sortdetail-container li.video-no-tag")
            lives.map do |live|
                {
                    "detail" => {
                        url: "http://www.panda.tv" + live.search("a").attr("href").text,
                        img_url: live.search("img").attr("data-original").text,
                        name: live.search("span.video-nickname").text.strip,
                        title: live.search("span.video-title").text.strip,
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
                        title: live.search("a.title").children[0].text.strip,
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
                        title: live.search("span.name").text.strip,
                        platform: "战旗"
                    },
                    "num" => live.search("span.dv").first.text
                }
            end
        end

        def longzhu_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("a.livecard")
            lives.map do |live|
                {
                    "detail" => {
                        url: live.attributes["href"].value,
                        img_url: live.search("img")[0].attributes["src"].value,
                        name: live.search("strong.livecard-modal-username")[0].children.text,
                        title: live.search("h3.listcard-caption").children.text.strip,
                        platform: "龙珠"
                    },
                    "num" => live.search("span.livecard-meta-item-text").children[0].text
                }
            end
        end

        def quanmin_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("li.list_w-video")
            lives.map do |live|
                {
                    "detail" => {
                        url: "http://www.quanmin.tv" + live.search("a.common_w-card_href")[0].attributes["href"].value.split(".tv").last,
                        img_url: live.search("img.common_w-card_cover")[0].attributes["src"].value,
                        name: live.search("span.common_w-card_host-name")[0].children.text,
                        title: live.search("p.common_w-card_title")[0].children.text.strip,
                        platform: "全民"
                    },
                    "num" => live.search("span.common_w-card_views-num")[0].children.text
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
